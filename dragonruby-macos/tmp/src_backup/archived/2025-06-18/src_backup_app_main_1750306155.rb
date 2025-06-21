def tick args
  args.state.dvd ||= { x: 640,
                       y: 360,
                       w: 64,
                       h: 64,
                       path: "sprites/square/red.png",
                       dx: 5,
                       dy: 5,}

  args.state.boundaries ||= [
    { target: {x: 0, y: 0, w: 5, h: 720}, growth_direction: {x: 0, y: 0, w: 8, h: 0}, min_size: {w:5, h: 720}, bouncedir: {x: 5, y: 0}, x: 0, y: 0, w: 5, h: 720, path: :solid, r: 0, g: 0, b: 0, maxclicks:65},
    { target: {x: 1275, y: 0, w: 5, h: 720}, growth_direction: {x: -8, y: 0, w: 8, h: 0}, min_size: {w:5, h: 720}, bouncedir: {x: -5, y: 0}, x: 1275, y: 0, w: 5, h: 720, path: :solid, r: 0, g: 0, b: 0, maxclicks:65},
    { target: {x: 0, y: 0, w: 1280, h: 5}, growth_direction: {x: 0, y: 0, w: 0, h: 5}, min_size: {w:1280, h: 5}, bouncedir: {x: 0, y: 5}, x: 0, y: 0, w: 1280, h: 5, path: :solid, r: 0, g: 0, b: 0, maxclicks:100000},
    { target: {x: 0, y: 715, w: 1280, h: 5}, growth_direction: {x: 0, y: -5, w: 0, h: 5}, min_size: {w:1280, h: 5}, bouncedir: {x: 0, y: -5}, x: 0, y: 715, w: 1280, h: 5, path: :solid, r: 0, g: 0, b: 0, maxclicks:100000},
  ] 

  args.state.numclicks ||= 0
  args.outputs.sprites << args.state.boundaries
  args.outputs.sprites << args.state.dvd

  args.state.boundaries.find do |boundary|
    if Geometry.intersect_rect?(args.state.dvd, boundary)
      if boundary.bouncedir.x != 0
        args.state.dvd.dx = boundary.bouncedir.x 
      else
        args.state.dvd.dy = boundary.bouncedir.y
      end
    end
  end

  args.state.dvd.x += args.state.dvd.dx
  args.state.dvd.y += args.state.dvd.dy

  dvd = args.state.dvd

  args.state.boundaries.each do |boundary|
    # Calculate where this boundary should stop based on DVD position
    should_shrink = true
    
    if boundary.bouncedir[:x] == 5  # Left wall
      # Stop when the right edge would touch the DVD's left edge
      should_shrink = (boundary.target.x + boundary.target.w + boundary.growth_direction.w) < dvd.x
    elsif boundary.bouncedir[:x] == -5  # Right wall  
      # Stop when the left edge would touch the DVD's right edge
      should_shrink = (boundary.target.x + boundary.growth_direction.x) > (dvd.x + dvd.w)
    elsif boundary.bouncedir[:y] == 5  # Bottom wall
      # Stop when the top edge would touch the DVD's bottom edge  
      should_shrink = (boundary.target.y + boundary.target.h + boundary.growth_direction.h) < dvd.y
    elsif boundary.bouncedir[:y] == -5  # Top wall
      # Stop when the bottom edge would touch the DVD's top edge
      should_shrink = (boundary.target.y + boundary.growth_direction.y) > (dvd.y + dvd.h)
    end

    # Only shrink if we haven't reached the DVD and we're above minimum size
    if should_shrink && 
       boundary.target.w + boundary.growth_direction.w >= boundary.min_size[:w] &&
       boundary.target.h + boundary.growth_direction.h >= boundary.min_size[:h]
      boundary.target.x += boundary.growth_direction.x
      boundary.target.y += boundary.growth_direction.y
      boundary.target.w += boundary.growth_direction.w
      boundary.target.h += boundary.growth_direction.h
    end
  end
    
  args.state.boundaries.each do |boundary|
    boundary.x = boundary.x.lerp(boundary.target.x, 0.1)
    boundary.y = boundary.y.lerp(boundary.target.y, 0.1)
    boundary.w = boundary.w.lerp(boundary.target.w, 0.1)
    boundary.h = boundary.h.lerp(boundary.target.h, 0.1)
  end
end