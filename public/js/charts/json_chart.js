var data; // a global

d3.json("http://stampyday.pp.local:4567/by_day?month=2011.1&result=delivered", function(json) {
    data = json['days'];
    arr = Array(data.length);
    for (var key in data) {
      if (data.hasOwnProperty(key)) {
        arr.push(data[key]);
      }
    }
    arr.splice(0,1);
    data = arr,
        w = 400,
        h = 200,
        margin = 20,
        y = d3.scale.linear().domain([0, d3.max(data)]).range([0 + margin, h - margin]),
        x = d3.scale.linear().domain([0, data.length]).range([0 + margin, w - margin]);

    var vis = d3.select("body")
        .append("svg:svg")
        .attr("width", w)
        .attr("height", h)

    var g = vis.append("svg:g")
        .attr("transform", "translate(0, 200)");
    
    var line = d3.svg.line()
        .x(function(d,i) { return x(i); })
        .y(function(d) { return -1 * y(d); })
    
    g.append("svg:path").attr("d", line(data));
    
    g.append("svg:line")
        .attr("x1", x(0))
        .attr("y1", -1 * y(0))
        .attr("x2", x(w))
        .attr("y2", -1 * y(0))

    g.append("svg:line")
        .attr("x1", x(0))
        .attr("y1", -1 * y(0))
        .attr("x2", x(0))
        .attr("y2", -1 * y(d3.max(data)))
    
    g.selectAll(".xLabel")
        .data(x.ticks(5))
        .enter().append("svg:text")
        .attr("class", "xLabel")
        .text(String)
        .attr("x", function(d) { return x(d) })
        .attr("y", 0)
        .attr("text-anchor", "middle")

    g.selectAll(".yLabel")
        .data(y.ticks(4))
        .enter().append("svg:text")
        .attr("class", "yLabel")
        .text(String)
        .attr("x", 0)
        .attr("y", function(d) { return -1 * y(d) })
        .attr("text-anchor", "right")
        .attr("dy", 4)
    
    g.selectAll(".xTicks")
        .data(x.ticks(5))
        .enter().append("svg:line")
        .attr("class", "xTicks")
        .attr("x1", function(d) { return x(d); })
        .attr("y1", -1 * y(0))
        .attr("x2", function(d) { return x(d); })
        .attr("y2", -1 * y(-0.3))

    g.selectAll(".yTicks")
        .data(y.ticks(4))
        .enter().append("svg:line")
        .attr("class", "yTicks")
        .attr("y1", function(d) { return -1 * y(d); })
        .attr("x1", x(-0.3))
        .attr("y2", function(d) { return -1 * y(d); })
        .attr("x2", x(0))
});