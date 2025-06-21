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
    # Add flag to boundary if it doesn't exist yet
    boundary[:stop_shrinking] ||= false

    # Only check shrink collision if not already stopped
    unless boundary[:stop_shrinking]
      if boundary.bouncedir[:x] == 5  # Left wall - stop when right edge touches DVD left edge
        boundary[:stop_shrinking] = boundary.target.x + boundary.target.w >= dvd.x
      elsif boundary.bouncedir[:x] == -5  # Right wall - stop when left edge touches DVD right edge
        boundary[:stop_shrinking] = boundary.target.x <= dvd.x + dvd.w
      elsif boundary.bouncedir[:y] == 5  # Bottom wall - stop when top edge touches DVD bottom edge
        boundary[:stop_shrinking] = boundary.target.y + boundary.target.h >= dvd.y
      elsif boundary.bouncedir[:y] == -5  # Top wall - stop when bottom edge touches DVD top edge
        boundary[:stop_shrinking] = boundary.target.y <= dvd.y + dvd.h
      end
    end

    # Skip this boundary if it's marked to stop shrinking
    next if boundary[:stop_shrinking]

    if boundary.target.w + boundary.growth_direction.w >= boundary.min_size[:w] &&
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