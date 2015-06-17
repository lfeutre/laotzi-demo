var chart = circularHeatChart()
    .segmentHeight(10)
    .innerRadius(0)
    .numSegments(100)
    .radialLabels(null)
    .segmentLabels(null)
    .margin({top: 20, right: 0, bottom: 50, left: 200});

chart.accessor(function(d) {return d.value;})
    .range(["yellow", "red"]);

var svg = d3.select('#chart')
    .append("svg");

function update (data) {
    console.log("Updating ...");
    console.log(data[0]);
    svg.data([data])
        .call(chart);

    /* Add a mouseover event */
    d3.selectAll("#chart path").on('mouseover', function() {
        var d = d3.select(this).data()[0];
        d3.select("#info").text(d.title + ' has value ' + d.value);
    });
    d3.selectAll("#chart svg").on('mouseout', function() {
        d3.select("#info").text('');
    });
};

function poll() {
    $.ajax({
        url: "/data.json",
        type: "GET",
        dataType: "json",
        success: update
    });
};
