module CampaignsHelper
    def status_color_class(status)
        case status
        when 'draft'
            'bg-gray-300 text-gray-800'
        when 'active'
            'bg-green-300 text-green-800'
        when 'paused'
            'bg-yellow-300 text-yellow-800'
        when 'completed'
            'bg-blue-300 text-blue-800'
        else
            'bg-gray-300 text-gray-800'
        end
    end
end