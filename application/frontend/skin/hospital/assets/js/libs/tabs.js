/**
 * Tabs
 *
 * @module ls/tabs
 *
 * @license   GNU General Public License, version 2
 * @copyright 2013 OOO "ЛС-СОФТ" {@link http://livestreetcms.com}
 * @author    Denis Shakhov <denis.shakhov@gmail.com>
 */

(function($) {
    "use strict";

    $.fn.lsTabs = function(opt) {
        var aTab = this;
        /**
         * Дефолтные опции
         */
        var options = {
            // Селекторы
            selectors: {
                tab: '[data-tab-list]:first [data-tab]',
                pane: '[data-tab-panes]:first [data-tab-pane]'
            }
        };
        $.extend(options, opt);

        aTab.each(function(){
            var parent = this;
            $(parent).find(options.selectors.tab).on('click', function(){
                var aData = $(this).data('lstab-options');
                $(parent).find('.active').removeClass('active');
                $(this).addClass('active');
                $(parent).find(options.selectors.pane).hide();
                $('#'+aData.target).show();
            });
        });
    }
})(jQuery);