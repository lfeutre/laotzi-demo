var chart = circularHeatChart()
    .segmentHeight(20)
    .innerRadius(20)
    .numSegments(24)
    .radialLabels(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"])
    .segmentLabels(["Midnight", "1am", "2am", "3am", "4am", "5am", "6am", "7am", "8am", "9am", "10am", "11am", "Midday", "1pm", "2pm", "3pm", "4pm", "5pm", "6pm", "7pm", "8pm", "9pm", "10pm", "11pm"])
    .margin({top: 20, right: 0, bottom: 20, left: 280});

/* An array of objects */
data = [];
for(var i=0; i<240; i++) {
    data[i] = {title: "Segment "+i, value: Math.round(Math.random()*100)};
}

chart.accessor(function(d) {return d.value;})
    .radialLabels(null)
    .segmentLabels(null);
d3.select('#chart4')
    .selectAll('svg')
    .data([data])
    .enter()
    .append('svg')
    .call(chart);

/* Add a mouseover event */
d3.selectAll("#chart4 path").on('mouseover', function() {
  var d = d3.select(this).data()[0];
    d3.select("#info").text(d.title + ' has value ' + d.value);
});
d3.selectAll("#chart4 svg").on('mouseout', function() {
    d3.select("#info").text('');  
});
