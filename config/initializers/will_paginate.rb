# /root/TO-DO_List/config/initializers/will_paginate.rb

if defined?(WillPaginate::ActionView::Base)
  WillPaginate::ActionView::Base.field_error_proc = Proc.new { |input, instance| input }
end


