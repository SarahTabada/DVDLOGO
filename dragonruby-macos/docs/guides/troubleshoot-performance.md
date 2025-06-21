# Troubleshoot Performance

## Benchmark

To benchmark variations of a method you can use `GTK.benchmark` (see
`Runtime` docs for details).

## Recursion

Avoid deep recursive calls convert to a loop instead.

## Rendering Primitives
- If you're using `Arrays` for your primitives (`args.outputs.sprites
  << []`), use `Hash` instead (`args.outputs.sprites << { x: ... }`).
- Use `.each` instead of `.map` if you don't care about the return value.
- When concatenating primitives to outputs, do them in bulk.

Instead of:

```ruby
args.state.bullets.each do |bullet|
  args.outputs.sprites << bullet.sprite
end
```

Do

```ruby
args.outputs.sprites << args.state.bullets.map do |b|
  b.sprite
end
```

- Consider using a `render_target` if you're doing some form of a
  camera that moves a lot of primitives (take a look at the Render
  Target sample apps for more info).

## Array Manipulation
Avoid deleting or adding to an array during iteration. Instead of:

  ```ruby
  args.state.bullets.each do |bullet|
    args.state.fx_queue.each |fx|
      fx.count_down ||= 255
      fx.countdown -= 5
      if fx.countdown < 0
        args.state.fx_queue.delete fx
      end
    end
  end
  ```

Do:

  ```ruby
  args.state.bullets.each do |bullet|
    args.state.fx_queue.each |fx|
      fx.countdown ||= 255
      fx.countdown -= 5
    end
  end

  args.state.fx_queue.reject! { |fx| fx.countdown < 0 }
  ```

Consider using `class` level variants for `Array` (you may find them to be
a bit faster). Here are the methods that are available at the class
level.

!> These methods assume that you are not mutating the collection during iteration.

- `map`
- `map!`
- `map_with_index`
- `each`
- `each_with_index`
- `reject`
- `reject!`
- `find_all`
- `select`
- `select!`
- `compact`
- `compact!`
- `filter_map`
- `flat_map`

Usage example. Instead of:

```ruby
new_things = current_things.map do |t|
  ...
end
```

Do:

```ruby
new_things = Array.map(current_things) do |t|
  ...
end
```
