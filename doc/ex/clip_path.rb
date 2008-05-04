#! /usr/local/bin/ruby -w

require 'RMagick'

points = [145, 65, 174,151, 264,151, 192,205,
          218,291, 145,240,  72,291,  98,205,
           26,151, 116,151]

pr = Magick::Draw.new

# Define a clip-path.
# The name of the clip-path is "example"
pr.define_clip_path('example') {
    pr.polygon(*points)
    }

# Enable the clip-path
pr.push
pr.clip_path('example')

# Composite the Flower Hat image over
# the background using the clip-path
girl = Magick::ImageList.new
girl.read("images/Flower_Hat.jpg")

cols = rows = nil

# Our final image is about 290 pixels wide, so here
# we widen our picture to fit.

girl.resize!(290.0/girl.columns)
cols = girl.columns
rows = girl.rows
pr.composite(0, 0, cols, rows, girl)

pr.pop

# Create a canvas to draw on, a bit bigger than the star.
canvas = Magick::Image.new(cols, rows)

star = Magick::Draw.new
star.stroke('black')
star.fill('black')
star.polygon(*points)
star.draw(canvas)
canvas = canvas.blur_image(0, 20)

# Draw the star over the background
pr.draw(canvas)

canvas.write("clip_path.gif")

exit
