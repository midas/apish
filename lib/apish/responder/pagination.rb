module Apish::Responder::Pagination

  def respond(*args)
    if paginated?
      controller.headers['X-Total-Entries'] = resource.total_entries.to_s
      controller.headers['X-Total-Pages']   = resource.total_pages.to_s
      controller.headers['X-Current-Page']  = resource.current_page.to_s
      controller.headers['X-Next-Page']     = resource.next_page.to_s
      controller.headers['X-Previous-Page'] = resource.previous_page.to_s
      controller.headers['X-Per-Page']      = resource.per_page.to_s
    end

    super( *args )
  end

private

  def paginated?
    resource.respond_to?(:total_entries) &&
      resource.respond_to?(:total_pages) &&
      resource.respond_to?(:per_page)
  end

end
