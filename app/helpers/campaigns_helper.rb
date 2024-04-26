module CampaignsHelper
    def status_color_class(status)
        case status
        when 'draft'
            'ring-gray-500/10 text-gray-600 bg-gray-50 dark:text-gray-400 dark:bg-gray-400/10 dark:ring-gray-400/30'
        when 'active'
            'ring-green-600/20 text-green-700 bg-green-50 dark:text-green-400 dark:bg-green-400/10 dark:ring-green-400/30'
        when 'paused'
            'ring-yellow-600/20 text-yellow-800 bg-yellow-50 dark:text-yellow-400 dark:bg-yellow-400/10 dark:ring-yellow-400/30'
        when 'test'
            'ring-blue-700/10 text-blue-700 bg-blue-50 dark:text-blue-400 dark:bg-blue-400/10 dark:ring-blue-400/30'
        else
            'ring-gray-500/10 text-gray-600 bg-gray-50 dark:text-gray-400 dark:bg-gray-400/10 dark:ring-gray-400/30'
        end
    end

    def percentage_change(start_value, end_value)
        if start_value.zero?
            "<dd class='text-xs font-medium text-green-700'>+0%</dd>".html_safe
        else 
            change = ((end_value - start_value).to_f / start_value) * 100

            if change > 0 
                "<dd class='text-xs font-medium text-green-700'>+#{change}%</dd>".html_safe
            elsif change < 0 
                "<dd class='text-xs font-medium text-red-700'>-#{change}%</dd>".html_safe
            else 
                "<dd class='text-xs font-medium text-gray-700'>-#{change}%</dd>".html_safe
            end 
        end
    end
end