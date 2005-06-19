#--
# $Id: clippath.rb,v 1.1 2005/03/12 17:02:00 rmagick Exp $
# Copyright (C) 2005 Timothy P. Hunter
#++
class Magick::RVG

    class ClipPath
        include ShapeConstructors
        include UseConstructors
        include TextConstructors
        include Describable
        include Stylable
        include Duplicatable

        # Create a clipping path. Within the block create an outline
        # from one or more paths, basic shapes, text objects, or +use+.
        # Everything drawn within the outline will be displayed.
        # Anything drawn outside the outline will not.
        #
        # If the clipping path contains a +use+, it
        # must directly reference path, basic shape, or text objects.
        #
        # Attach the clipping path to an object with the :clip_path style.
        def initialize(clip_path_units='userSpaceOnUse')
            super()
            if ! ['userSpaceOnUse', 'objectBoundingBox'].include?(clip_path_units)
                raise ArgumentError, "undefined value for clip path units: #{clip_path_units}"
            end
            @clip_path_units = clip_path_units
            @content = Content.new
            yield(self) if block_given?
        end

        def add_primitives(gc, style)   #:nodoc:
            name = __id__.to_s
            gc.define_clip_path(name) do
                gc.clip_units(@clip_path_units)
                @content.each { |element| element.add_primitives(gc) }
            end
            gc.clip_path(name)
        end

    end     # class ClipPath

end     # class Magick::RVG
