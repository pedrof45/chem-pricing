module ActiveAdmin
  module Views
    class PaginatedCollection < ActiveAdmin::Component
      def build_pagination_with_formats(options)
        return if params[:controller] == 'icms_taxes'
        div id: "index_footer" do
          build_per_page_select if @per_page.is_a?(Array)
          build_pagination
          div(page_entries_info(options).html_safe, class: "pagination_information")

          formats = build_download_formats @download_links
          build_download_format_links formats if formats.any?
        end
      end
    end
  end
end