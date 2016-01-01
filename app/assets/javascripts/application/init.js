var Rocketboard = function() {

    $(function() {
        toggleSettings();
        navToggleRight();
        navToggleLeft();
        navToggleSub();
        profileToggle();
        widgetToggle();
        widgetClose();
        widgetFlip();
        tooltips();
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

    var navToggleRight = function() {
        $('#toggle-right').on('click', function() {
            $('#sidebar-right').toggleClass('sidebar-right-open');
            $("#toggle-right .fa").toggleClass("fa-indent fa-dedent");

        });
    };

    var customCheckbox = function() {
        $('input.icheck').iCheck({
            checkboxClass: 'icheckbox_flat-grey',
            radioClass: 'iradio_flat-grey'
        });
    }

    var formMask = function() {
        $("#input1").mask("99/99/9999");
        $("#input2").mask('(999) 999-9999');
        $("#input3").mask("(999) 999-9999? x99999");
        $("#input4").mask("99-9999999");
        $("#input5").mask("999-99-9999");
        $("#input6").mask("a*-999-a999");
    }

    var weather = function() {
        var icons = new Skycons({
            "color": "#27B6AF"
        });

        icons.set("clear-day", Skycons.CLEAR_DAY);
        icons.set("clear-night", Skycons.CLEAR_NIGHT);
        icons.set("partly-cloudy-day", Skycons.PARTLY_CLOUDY_DAY);
        icons.set("partly-cloudy-night", Skycons.PARTLY_CLOUDY_NIGHT);
        icons.set("cloudy", Skycons.CLOUDY);
        icons.set("rain", Skycons.RAIN);
        icons.set("sleet", Skycons.SLEET);
        icons.set("snow", Skycons.SNOW);
        icons.set("wind", Skycons.WIND);
        icons.set("fog", Skycons.FOG);

        icons.play();
    }

    var formWizard = function() {
        $('#myWizard').wizard()
    }

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

    var widgetToggle = function() {
        $(".actions > .fa-chevron-down").click(function() {
            $(this).parent().parent().next().slideToggle("fast"), $(this).toggleClass("fa-chevron-down fa-chevron-up")
        });
    };

    var widgetClose = function() {
        $(".actions > .fa-times").click(function() {
            $(this).parent().parent().parent().fadeOut()
        });
    };

    var widgetFlip = function() {
        $(".actions > .fa-cog").click(function() {
            $(this).closest('.flip-wrapper').toggleClass('flipped')
        });
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
            maxDate: today.toJSON().slice(0,10)
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
                  scaleLabel : "<%= '$ ' + value  %>",
                  tooltipTemplate: "<%= '$ ' + value %>"
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

          drawAreaChart("/api/v1/data/chart/all");

          drawDoughnutChart("/api/v1/data/chart/usage");

        };

    };

    var formValidation = function() {
        $('#form').validate({
            rules: {
                input1: {
                    required: true
                },
                input2: {
                    minlength: 5,
                    required: true
                },
                input3: {
                    maxlength: 5,
                    required: true
                },
                input4: {
                    required: true,
                    minlength: 4,
                    maxlength: 8
                },
                input5: {
                    required: true,
                    min: 5
                },
                input6: {
                    required: true,
                    range: [5, 50]
                },
                input7: {
                    minlength: 5
                },
                input8: {
                    required: true,
                    minlength: 5,
                    equalTo: "#input7"
                },
                input9: {
                    required: true,
                    email: true
                },
                input10: {
                    required: true,
                    url: true
                },
                input11: {
                    required: true,
                    digits: true
                },
                input12: {
                    required: true,
                    phoneUS: true
                },
                input13: {
                    required: true,
                    minlength: 5
                }
            },
            highlight: function(element) {
                $(element).closest('.form-group').removeClass('success').addClass('error');
            },
            success: function(element) {
                element.text('OK!').addClass('valid')
                    .closest('.form-group').removeClass('error').addClass('success');
            }
        });
    }


    var spinStart = function(spinOn) {
        var spinFull = $('<div class="preloader"><div class="iconWrapper"><i class="fa fa-circle-o-notch fa-spin"></i></div></div>');
        var spinInner = $('<div class="preloader preloader-inner"><div class="iconWrapper"><i class="fa fa-circle-o-notch fa-spin"></i></div></div>');
        if (spinOn === undefined) {
            $('body').prepend(spinFull);
        } else {
            $(spinOn).prepend(spinInner);
        };
    };

    var spinStop = function() {
        $('.preloader').remove();
    };


    return {
        dateRangePicker: dateRangePicker,
        chartJs: chartJs,
        customCheckbox: customCheckbox,
        formValidation: formValidation,
        formWizard: formWizard
    };

}();

$(window).resize(function() {
    Rocketboard.chartJs();
});