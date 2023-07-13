module CampaignsHelper
    def status_color_class(status)
        case status
        when 'draft'
            'bg-gray-50 text-gray-700 ring-gray-600/20'
        when 'active'
            'bg-green-50 text-green-700 ring-green-600/20'
        when 'paused'
            'bg-yellow-50 text-yellow-700 ring-yellow-600/20'
        when 'completed'
            'bg-blue-50 text-blue-700 ring-blue-600/20'
        else
            'bg-gray-50 text-gray-700 ring-gray-600/20'
        end
    end
end