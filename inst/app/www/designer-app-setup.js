$(document).ready(function() {
  $(".help-icon").tooltip({
    boundary: "window",
    placement: "right"
  });

  $("#settings-page_type").on("change", updateCanvasCheck);
  updatePage();

  $("#confirm_reset").on("click", updatePage);
  $(".copy-ui-button").on("click", copyUICode);

  $(document).on("click", ".clickable-dropdown", e => { e.stopPropagation(); });

  $("#remove_label").change(toggleComponentLabels);
  $("#remove_colour").change(toggleBackgroundColours);
  $("#remove_border").change(toggleBorders);
  $("#preview").on("click", () => { $(".page-canvas-shell").addClass("preview"); });
  $("#canvas-close_preview").on("click", () => { $(".page-canvas-shell").removeClass("preview"); });

  $("#app_name").on("change", el => {
    const title = $(el.target).val();
    $("#canvas-title").html(title);
    $(".navbar-brand").html(title);

    if ($("#canvas-page").data("shinyattributes")) {
      var shiny_atts = $("#canvas-page").data("shinyattributes").replace(/"[^"]+"/, `"${title}"`);
      $("#canvas-page").attr("data-shinyattributes", shiny_atts);
    }
  });

  Sortable.create(document.getElementById("sidebar-bin"), {
    group: {
      name: "shared",
      pull: false
    },
    handle: ".designer-element",
    draggable: ".designer-element",
    onAdd: function (evt) {
      this.el.removeChild(evt.item);
    }
  });
});
