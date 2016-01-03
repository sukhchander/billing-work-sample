var Rocketboard = function() {

    $(function() {
        toggleSettings();
        navToggleLeft();
        navToggleSub();
    });

    var toggleSettings = function() {
        $('.config-link').click(function() {
            if ($(this).hasClass('open')) {
                $('#config').animate({
                    "right": "-205px"
                }, 150);
                $(this).removeClass('open').addClass('closed');
            } else {
                $("#config").animate({
                    "right": "0px"
                }, 150);
                $(this).removeClass('closed').addClass('open');
            }
        });
    };

    var navToggleLeft = function() {
        $('#toggle-left').on('click', function() {
            var bodyEl = $('#main-wrapper');
            ($(window).width() > 767) ? $(bodyEl).toggleClass('sidebar-mini'): $(bodyEl).toggleClass('sidebar-opened');
        });
    };

    var navToggleSub = function() {
        var subMenu = $('.sidebar .nav');
        $(subMenu).navgoco({
            caretHtml: false,
            accordion: true
        });
    };

    var profileToggle = function() {
        $('#toggle-profile').click(function() {
            $('.sidebar-profile').slideToggle();
        });
    };


    function cb(start, end) {
      $('#reportrange span').html(start.format('YYYY-MM-DD') + ' - ' + end.format('YYYY-MM-DD'));
    }
    cb(moment().subtract(29, 'days'), moment());

    var dateRangePicker = function() {
        var today = new Date();
        today.setMonth(today.getMonth(),0)
        var start = new Date();
        start.setMonth(start.getMonth()-6);
        var min = new Date();
        min.setMonth(min.getMonth()-12);

        $('input[name="daterange"]').daterangepicker({
          opens: "left",
          format: 'YYYY-MM-DD',
          startDate: start.toJSON().slice(0,10),
          endDate: today.toJSON().slice(0,10),
          minDate: min.toJSON().slice(0,10),
          maxDate: today.toJSON().slice(0,10),
          ranges: {
           'Today': [moment(), moment()],
           'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
           'Last 7 Days': [moment().subtract(6, 'days'), moment()],
           'Last 30 Days': [moment().subtract(29, 'days'), moment()],
           'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
          }
        });

        $('input[name="daterange"]').on('apply.daterangepicker', function(ev, picker) {
          console.log(picker.startDate.format('YYYY-MM-DD'));
          console.log(picker.endDate.format('YYYY-MM-DD'));
        });
    };

    var tooltips = function() {
        $('.tooltip-wrapper').tooltip({
            selector: "[data-toggle=tooltip]",
            container: "body"
        })
    };

    var sliders = function() {
        $('.slider-span').slider()
    };

    var chartJs = function() {

        var areaChartData = {};
        var drawAreaChart = function (url) {
          $.ajax({
              url: url,
              method: 'GET',
              dataType: 'json',
              success: function (d) {

                areaChartData = {
                  labels: d.xAxis,
                  datasets: [{
                    //fillColor: 'rgba(26,188,156,0.5)',
                    //strokeColor: 'rgba(26,188,156,1)',
                    //pointColor: 'rgba(220,220,220,1)',
                    fillColor: "rgba(151,187,205,0.2)",
                    strokeColor: "rgba(151,187,205,1)",
                    pointColor: "rgba(151,187,205,1)",
                    pointStrokeColor: '#fff',
                    pointHighlightFill: '#fff',
                    pointHighlightStroke: 'rgba(220,220,220,1)',
                    data: d.zAxis
                  }]
                };
                //console.log(areaChartData.labels);
                //console.log(areaChartData.datasets[0]["data"]);

                var ctx1 = document.getElementById("canvas1").getContext("2d");
                window.myLine = new Chart(ctx1).Line(areaChartData, {
                  responsive: true,
                  scaleLabel : "<%= accounting.formatMoney(value) %>",
                  tooltipTemplate: "<%= accounting.formatMoney(value) %>"
                });

            }
          });
        };

        var doughnutChartData = [];
        var drawDoughnutChart = function (url) {
          $.ajax({
            url: url,
            method: 'GET',
            dataType: 'json',
            success: function (d) {

              doughnutChartData = d.data;

              var ctx3 = document.getElementById("doughnut-chart-area").getContext("2d");
              window.myDoughnut = new Chart(ctx3).Doughnut(doughnutChartData, {
                responsive: true
              });
            }
          });
        };

        window.onload = function() {

          drawAreaChart("/api/v1/data/chart/aggregate");

          drawDoughnutChart("/api/v1/data/chart/breakdown_product");

        };

    };

    var drawAreaChart = function(url,selector) {
      var areaChartData = {};
      $.ajax({
          url: url,
          method: 'GET',
          dataType: 'json',
          success: function (d) {

            areaChartData = {
              labels: d.xAxis,
              datasets: [{
                //fillColor: 'rgba(26,188,156,0.5)',
                //strokeColor: 'rgba(26,188,156,1)',
                //pointColor: 'rgba(220,220,220,1)',
                fillColor: "rgba(151,187,205,0.2)",
                strokeColor: "rgba(151,187,205,1)",
                pointColor: "rgba(151,187,205,1)",
                pointStrokeColor: '#fff',
                pointHighlightFill: '#fff',
                pointHighlightStroke: 'rgba(220,220,220,1)',
                data: d.zAxis
              }]
            };
            //console.log(areaChartData.labels);
            //console.log(areaChartData.datasets[0]["data"]);

            var context = document.getElementById(selector).getContext("2d");
            window.myLine = new Chart(context).Line(areaChartData, {
              responsive: true,
              scaleLabel : "<%= accounting.formatMoney(value) %>",
              tooltipTemplate: "<%= accounting.formatMoney(value) %>"
            });

        }
      });
    };

    return {
        dateRangePicker: dateRangePicker,
        chartJs: chartJs,
        drawAreaChart: drawAreaChart
    };

}();

$(window).resize(function() {
    Rocketboard.chartJs();
});