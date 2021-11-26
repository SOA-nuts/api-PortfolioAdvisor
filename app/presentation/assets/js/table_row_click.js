$(document).ready(function() {
    $(".table-row").click(function() {
      window.document.location = $(this).data("href");
    });

    $(".article_table_row").click(function() {
      window.open($(this).data("href"));
    });
  });

  window.onload = function(){
    var update_time =[]
    var score = []
    var index = 0;
    $("table#history_table tr").each(function() {
        var arrayOfThisRow = [];
        var tableData = $(this).find('td');
        
        if (tableData.length > 0) {
            tableData.each(function() { arrayOfThisRow.push($(this).text()); });
            update_time[index] = arrayOfThisRow[0];
            score[index] = arrayOfThisRow[1];
            index++;
        }
     });

     var ctxL = $(".LineChart")
     var myLineChart = new Chart(ctxL, {
       type: 'line',      
       data: {
         labels: update_time,
         datasets: [{
           backgroundColor: "rgba(0,0,0,1.0)",
           borderColor: "rgba(0,0,0,0.1)",
           data: score
         }]
       },
       options: {
         responsive: true
       }
     });
     
    }
    // var chart = BuildChart(labels, myTableArray, "Items Sold Over Time");

    


