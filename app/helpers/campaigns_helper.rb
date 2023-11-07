module CampaignsHelper
    def status_color_class(status)
        case status
        when 'draft'
            'text-gray-400 bg-gray-400/10'
        when 'active'
            'text-green-400 bg-green-400/10'
        when 'paused'
            'text-yellow-400 bg-yellow-400/10'
        when 'completed'
            'text-blue-400 bg-blue-400/10'
        else
            'text-gray-400 bg-gray-400/10'
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