window.Foundation = {
  init: function() {
    (function ($, window, undefined) {
      var $doc = $(document);
      
      $.fn.foundationAlerts           ? $doc.foundationAlerts() : null;
      $.fn.foundationAccordion        ? $doc.foundationAccordion() : null;
      $.fn.foundationTooltips         ? $doc.foundationTooltips() : null;
      $('input, textarea').placeholder();
      $.fn.foundationButtons          ? $doc.foundationButtons() : null;
      $.fn.foundationNavigation       ? $doc.foundationNavigation() : null;
      $.fn.foundationTopBar           ? $doc.foundationTopBar() : null;
      $.fn.foundationCustomForms      ? $doc.foundationCustomForms() : null;
      $.fn.foundationMediaQueryViewer ? $doc.foundationMediaQueryViewer() : null;
      $.fn.foundationTabs             ? $doc.foundationTabs() : null;

      // Hide address bar on mobile devices
      if (window.Modernizr.touch) {
        $(window).load(function () {
          setTimeout(function () {
            window.scrollTo(0, 1);
          }, 0);
        });
      }
    })(jQuery, window);
  }
};