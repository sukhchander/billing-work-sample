var Application = function() {

    $(function() {
        navToggleLeft();
        navToggleSub();
    });

    var navToggleLeft = function() {
        $('#toggle-left').on('click', function() {
            var bodyEl = $('#main-wrapper');
            if ($(window).width() > 767) {
              $(bodyEl).toggleClass('sidebar-mini');
            } else {
              $(bodyEl).toggleClass('sidebar-opened');
            }
        });
    };

    var navToggleSub = function() {
        var subMenu = $('.sidebar .nav');
        $(subMenu).navgoco({
            caretHtml: false,
            accordion: true
        });
    };

    var spinStart = function(spinOn) {
        var spinFull = $('<div class="preloader"><div class="iconWrapper"><i class="fa fa-circle-o-notch fa-spin fa-3x"></i></div></div>');
        var spinInner = $('<div class="preloader preloader-inner"><div class="iconWrapper"><i class="fa fa-circle-o-notch fa-spin fa-3x"></i></div></div>');
        if (spinOn === undefined) {
            $('body').prepend(spinFull);
        } else {
            $(spinOn).prepend(spinInner);
        };
    };

    var spinStop = function() {
        $('.preloader').fadeOut().remove();
    };

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

    var drawDonutChart = function (url, container) {
      var element = document.getElementById(container);
      spinStart($(element).parent());

      var data = [];
      $.ajax({
        url: url,
        method: 'GET',
        dataType: 'json',
        beforeSend: function () {
        },
        success: function (response) {

          spinStop($(element).parent());

          data = response.data;
          var context = document.getElementById(container).getContext("2d");
          window.donutChart = new Chart(context).Doughnut(data, {
            responsive: true
          });
        }
      });
    };

    var drawAreaChart = function(url, container) {
      var element = document.getElementById(container);
      spinStart($(element).parent());

      var data = {};
      $.ajax({
        url: url,
        method: 'GET',
        dataType: 'json',
        beforeSend: function () {
        },
        success: function (response) {

          spinStop($(element).parent());

          data = {
            labels: response.xAxis,
            datasets: [{
              fillColor: "rgba(151,187,205,0.2)",
              strokeColor: "rgba(151,187,205,1)",
              pointColor: "rgba(151,187,205,1)",
              pointStrokeColor: '#fff',
              pointHighlightFill: '#fff',
              pointHighlightStroke: 'rgba(220,220,220,1)',
              data: response.zAxis
            }]
          };

          var context = document.getElementById(container).getContext("2d");
          window.areaChart = new Chart(context).Line(data, {
            responsive: true,
            scaleLabel : "<%= accounting.formatMoney(value) %>",
            tooltipTemplate: "<%= accounting.formatMoney(value) %>"
          });
        }
      });
    };

    return {
        dateRangePicker: dateRangePicker,
        drawDonutChart: drawDonutChart,
        drawAreaChart: drawAreaChart
    };

}();