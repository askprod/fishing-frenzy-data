module FlashHelper
  def flash_style(type)
    case type.to_sym
    when :notice
      {
        container: "bg-blue-50 border-blue-400",
        icon: '<svg class="w-5 h-5 text-blue-600 mt-0.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M13 16h-1v-4h-1m1-4h.01M21 12c0 4.97-4.03 9-9 9s-9-4.03-9-9 4.03-9 9-9 9 4.03 9 9z"/></svg>'
      }
    when :alert, :error
      {
        container: "bg-red-50 border-red-400",
        icon: '<svg class="w-5 h-5 text-red-600 mt-0.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M18.364 5.636L5.636 18.364M5.636 5.636l12.728 12.728"/></svg>'
      }
    when :success
      {
        container: "bg-green-50 border-green-400",
        icon: '<svg class="w-5 h-5 text-green-600 mt-0.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/></svg>'
      }
    else
      {
        container: "bg-gray-50 border-gray-300",
        icon: ""
      }
    end
  end
end
