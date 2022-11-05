(function() {
  function f() {

    /* js/datum.json */
    /* js/datum-measles.json */
    
    $.getJSON("js/datum-measles.json").then(function(c) { 
      g(c)
    });
  }

  function g(c) {
    var d = $(".box-wrapper");
    $.each(c, function(e, a) {
      var b;
      b = $("#entry-template").html();
      b = Handlebars.compile(b)(a);
      d.append(b);
      h(a.id, a.data.chart_options, a.data.values.data)
    })
  }

  function h(c, d, e) {
    var a = ["Alaska", "Ala.", "Ark.", "Ariz.", "Calif.", "Colo.", "Conn.", "D.C.", "Del.", "Fla.", "Ga.", "Hawaii",
      "Iowa", "Idaho", "Ill.", "Ind.", "Kan.", "Ky.", "La.", "Mass.", "Md.", "Maine", "Mich.", "Minn.", "Mo.", "Miss.", "Mont.", "N.C.", "N.D.", "Neb.", "N.H.", "N.J.", "N.M", "Nev.", "N.Y.", "Ohio", "Okla.", "Ore.", "Pa.", "R.I.", "S.C.", "S.D.", "Tenn.", "Texas", "Utah", "Va.", "Vt.", "Wash.", "Wis.", "W.Va.", "Wyo."
    ];
    $("[data-infection=" + c + "] .chart").highcharts({
      chart: {
        type: "heatmap",
        height: 550,
        marginLeft: 50,
        marginTop: 30,
        style: {
          color: "#000000",
          fontFamily: "'Whitney SSm', 'Helvetica Neue', Helvetica, Arial, sans-serif",
          fontWeight: "normal",
          fontStyle: "normal",
          fontSize: 13
        }
      },
      exporting: {
        enabled: false
      },
      credits: {
        enabled: false
      },
      title: {
        text: null
      },
      xAxis: {
        lineColor: "#999999",
        tickLength: 5,
        tickWidth: 1,
        tickColor: "#A7A5A3",
        tickmarkPlacement: "on",
        startOnTick: false,
        labels: {
          style: {
            color: "#000000",
            fontFamily: "'Whitney SSm', 'Helvetica Neue', Helvetica, Arial, sans-serif",
            fontWeight: "normal",
            fontStyle: "normal",
            fontSize: 12
          }
        },
        plotLines: [{
          color: "#000000",
          value: d.vaccine_year,
          width: 3,
          zIndex: 5,
          label: {
            text: "Vaccine introduced",
            verticalAlign: "top",
            textAlign: "left",
            rotation: 0,
            x: $(window).width() > 500 ? -4 : d.vaccine_x || -4,
            y: -5,
            style: {
              color: "#000000",
              fontFamily: "'Whitney SSm', 'Helvetica Neue', Helvetica, Arial, sans-serif",
              fontWeight: 500,
              fontStyle: "normal",
              fontSize: 12
            }
          }
        }],
        type: "string"
      },
      yAxis: {
        tickInterval: 1,
        reversed: true,
        max: 50,
        offset: -10,
        labels: {
          style: {
            color: "#000000",
            fontFamily: "'Whitney SSm', 'Helvetica Neue', Helvetica, Arial, sans-serif",
            fontWeight: "normal",
            fontStyle: "normal",
            paddingRight: 25,
            fontSize: 11
          },
          formatter: function() {
            return a[this.value]
          }
        },
        gridLineColor: "#FFFFFF",
        title: null
      },
      colorAxis: {
        min: 0,
        stops: [
          [0, "#e7f0fa"],
          [0.01, "#c9e2f6"],
          [0.02, "#95cbee"],
          [0.03, "#0099dc"],
          [0.09, "#4ab04a"],
          [0.1, "#ffd73e"],
          [0.15, "#eec73a"],
          [0.25, "#e29421"],
          [0.4, "#e29421"],
          [0.5, "#f05336"],
          [1, "#ce472e"]
        ]
      },
      legend: {
        enabled: true,
        margin: 0,
        y: 25,
        symbolHeight: 10,
        padding: 20,
        itemStyle: {
          color: "#000000",
          fontFamily: "'Whitney SSm', 'Helvetica Neue', Helvetica, Arial, sans-serif",
          fontWeight: "normal",
          fontStyle: "normal",
          fontSize: 13
        }
      },
      tooltip: {
        zIndex: 50,
        borderWidth: 1,
        borderRadius: 0,
        borderColor: "#ccc",
        style: {
          width: "400px",
          fontSize: "12px",
          fontFamily: "'Whitney SSm', 'Helvetica Neue', Helvetica, Arial, sans-serif",
          fontWeight: "normal",
          fontStyle: "normal",
          color: "#231F20"
        },
        formatter: function() {
          if (this.point.value === null) return a[this.point.y] + "<br>" + this.point.x + ": <b>N/A</b>";
          var b = this.point.value.toFixed(2);
          return a[this.point.y] + "<br>" + this.point.x + ": <b>" + b + "</b>"
        }
      },
      series: [{
        name: "S",
        borderWidth: 1,
        borderColor: "#fff",
        data: e,
        turboThreshold: 5E3,
        dataLabels: {
          enabled: false,
          color: "black",
          style: {
            textShadow: "none",
            HcTextStroke: null
          }
        }
      }]
    })
  }
  $(function() {
    f()
  })
})();
