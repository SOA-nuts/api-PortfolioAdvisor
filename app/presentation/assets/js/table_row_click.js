$(document).ready(function() {
    $(".table-row").click(function() {
      window.document.location = $(this).data("href");
    });

    $(".article_table_row").click(function() {
      window.open($(this).data("href"));
    });
  });
