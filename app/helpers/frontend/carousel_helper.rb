 module Frontend::CarouselHelper
#   def carousel_for(images)
#     Carousel.new(self, images).html
#   end
# end

# class Carousel
#   def initialize(view, images)
#     @view = view
#     @images = images
#   end

#   def html
#     content = view.safe_join([indicators, slides, controls])
#     view.content_tag(:div, content, class: 'carousel slide')
#   end

#   private

#   attr_accessor :view, :images
#   delegate :link_to, :content_tag, :image_tag, :safe_join, to: :view

#   def indicators
#     items = images.count.times.map {|index| indicator_tag(index)}  
#     content_tag(:ol, safe_join(items), class: "carousel-indicators")
#   end

#   def indicator_tag(index)
#     options = {
#       class : (index.zero? ? 'active' : '')  
#       data: {
#         target: "#image-carousel-cycleyard  ",
#         slide_to: index 
#       }  
#     }
    
#     content_tag(:li, '', options)
#   end


#   def slides
#     items = images.map.with_index { |index, image| slide_tag(image, index.zero?)}
#     content_tag(:div, safe_join(items), class: "carousel-inner")
#   end

#   def slide_tag(image, is_active)
#     options = {
#       class: is_active? ? 'item active' : 'item'
#     }
#     content_tag(:div, image_tag(image), options)
#   end

#   def controls
#     items = control_tag
#     content_tag(:div, safe_join(items) )
#   end


#     <!-- Controls -->
#   <a class="left carousel-control" href="#carousel-example-generic" data-slide="prev">
#     <span class="glyphicon glyphicon-chevron-left"></span>
#   </a>
#   <a class="right carousel-control" href="#carousel-example-generic" data-slide="next">
#     <span class="glyphicon glyphicon-chevron-right"></span>
#   </a>

 end
