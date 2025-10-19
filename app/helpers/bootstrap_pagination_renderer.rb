# app/helpers/bootstrap_pagination_renderer.rb
class BootstrapPaginationRenderer < WillPaginate::ActionView::LinkRenderer
  def html_container(html)
    tag(:nav, tag(:ul, html, class: 'pagination'), 'aria-label': 'Pagination')
  end

  def page_number(page)
    item_classes = "page-item#{' active' if page == current_page}"
    link_html = link(page, page, rel: rel_value(page), class: 'page-link')
    tag(:li, link_html, class: item_classes)
  end

  def previous_or_next_page(page, text, _classname)
    disabled = page ? '' : ' disabled'
    link_html = page ? link(text, page, class: 'page-link', rel: rel_value(page)) : tag(:span, text, class: 'page-link')
    tag(:li, link_html, class: "page-item#{disabled}")
  end
end