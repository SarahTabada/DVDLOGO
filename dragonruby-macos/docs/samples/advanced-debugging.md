### Unit Tests - main.rb
```ruby
  # ./samples/10_advanced_debugging/03_unit_tests/app/main.rb

```

### Unit Tests - benchmark_api_tests.rb
```ruby
  # ./samples/10_advanced_debugging/03_unit_tests/benchmark_api_tests.rb
  def test_benchmark_api args, assert
    result = GTK.benchmark iterations: 100,
                           only_one: -> () {
                             r = 0
                             (1..100).each do |i|
                               r += 1
                             end
                           }

    assert.equal! result.first_place.name, :only_one

    result = GTK.benchmark iterations: 100,
                           iterations_100: -> () {
                             r = 0
                             (1..100).each do |i|
                               r += 1
                             end
                           },
                           iterations_50: -> () {
                             r = 0
                             (1..50).each do |i|
                               r += 1
                             end
                           }

    assert.equal! result.first_place.name, :iterations_50

    result = GTK.benchmark iterations: 1,
                           iterations_100: -> () {
                             r = 0
                             (1..100).each do |i|
                               r += 1
                             end
                           },
                           iterations_50: -> () {
                             r = 0
                             (1..50).each do |i|
                               r += 1
                             end
                           }

    assert.equal! result.too_small_to_measure, true
  end

```

### Unit Tests - enumerable_class_function_tests.rb
```ruby
  # ./samples/10_advanced_debugging/03_unit_tests/enumerable_class_function_tests.rb
  def test_hash_find_all args, assert
    h = {
      x: 100,
      y: 200,
      w: 10,
      h: 10
    }

    result_expected = h.find_all { |k, v| v == 100 }
    result_actual = Hash.find_all(h) { |k, v| v == 100 }
    assert.equal! result_expected, result_actual
  end

  def test_hash_merge args, assert
    a = {
      x: 100,
      y: 200,
      w: 10,
      h: 10
    }

    b = {
      r: 255,
      g: 255,
      b: 255
    }

    result_expected = a.merge b
    result_actual = Hash.merge a, b
    assert.equal! result_actual, result_expected, "class implementation, matches instance implemenation"
    assert.not_equal! a.object_id, result_actual.object_id, "new hash created for merge"
  end

  def test_hash_all args, assert
    a = {
      x: 100,
      y: 200,
      w: 10,
      h: 10
    }

    result_expected = a.all? { |k, v| v.even? }
    result_actual = Hash.all?(a) { |k, v| v.even? }
    assert.equal! result_actual, result_expected, "class implementation, matches instance implemenation"

    result_expected = a.all? { |k, v| v.odd? }
    result_actual = Hash.all?(a) { |k, v| v.odd? }
    assert.equal! result_actual, result_expected, "class implementation, matches instance implemenation"

    result_expected = a.all? { |k, v| k.is_a? Symbol }
    result_actual = Hash.all?(a) { |k, v| k.is_a? Symbol }
    assert.equal! result_actual, result_expected, "class implementation, matches instance implemenation"

    result_expected = a.all? { |k, v| !k.is_a? Symbol }
    result_actual = Hash.all?(a) { |k, v| !k.is_a? Symbol }
    assert.equal! result_actual, result_expected, "class implementation, matches instance implemenation"
  end

  def test_hash_any args, assert
    a = {
      x: 100,
      y: 200,
      w: 10,
      h: 10
    }

    result_expected = a.any? { |k, v| v.even? }
    result_actual = Hash.any?(a) { |k, v| v.even? }
    assert.equal! result_actual, result_expected, "class implementation, matches instance implemenation"

    result_expected = a.any? { |k, v| v.odd? }
    result_actual = Hash.any?(a) { |k, v| v.odd? }
    assert.equal! result_actual, result_expected, "class implementation, matches instance implemenation"

    result_expected = a.any? { |k, v| k.is_a? Symbol }
    result_actual = Hash.any?(a) { |k, v| k.is_a? Symbol }
    assert.equal! result_actual, result_expected, "class implementation, matches instance implemenation"

    result_expected = a.any? { |k, v| !k.is_a? Symbol }
    result_actual = Hash.any?(a) { |k, v| !k.is_a? Symbol }
    assert.equal! result_actual, result_expected, "class implementation, matches instance implemenation"
  end

  def test_hash_merge_bang args, assert
    a = {
      x: 100,
      y: 200,
      w: 10,
      h: 10
    }

    b = {
      r: 255,
      g: 255,
      b: 255
    }

    a_2 = {
      x: 100,
      y: 200,
      w: 10,
      h: 10
    }

    b_2 = {
      r: 255,
      g: 255,
      b: 255
    }

    result_expected = a.merge! b
    result_actual = Hash.merge! a_2, b_2
    assert.equal! result_actual, result_expected, "class implementation, matches instance implemenation"
    assert.equal! a_2.object_id, result_actual.object_id, "hash updated for merge!"
  end

  def test_hash_merge_with_block args, assert
    a = {
      x: 100,
      y: 200,
      w: 10,
      h: 10
    }

    b = {
      x: 500,
    }

    result_expected = a.merge(b) do |k, current_value, new_value|
      current_value + new_value
    end

    result_actual = Hash.merge(a, b) do
      |k, current_value, new_value|
      current_value + new_value
    end

    assert.equal! result_expected[:x], result_actual[:x]
  end

  def test_array_map args, assert
    a = [1, 2, 3]

    result_expected = a.map do |i| i**2 end
    result_actual = Array.map a do |i| i**2 end
    assert.equal! result_expected, result_actual
    assert.not_equal! a.object_id, result_actual.object_id
  end

  def test_array_map_with_destructoring args, assert
    a = [[1, 2], [3, 4]]
    result_expected = a.map do |x, y| x + y end
    result_actual = Array.map a do |x, y| x + y end
    assert.equal! result_expected, result_actual
    assert.not_equal! a.object_id, result_actual.object_id

    a = [[1, 2], [3, 4]]
    result_expected = a.map.with_index do |(x, y), i| x + y + i end
    result_actual = Array.map_with_index a do |(x, y), i| x + y + i end
    assert.equal! result_expected, result_actual
    assert.not_equal! a.object_id, result_actual.object_id
  end

  def test_array_map_bang args, assert
    a = [1, 2, 3]
    result_expected = a.map do |i| i**2 end
    result_actual = Array.map! a do |i| i**2 end
    assert.equal! result_expected, result_actual
    assert.equal! a.object_id, result_actual.object_id
  end

  def test_array_reject args, assert
    a = [1, 2, 3, 4, 5, 6]
    result_expected = a.reject do |i| i.even? end
    result_actual = Array.reject a do |i| i.even? end
    assert.equal! result_expected, result_actual
    assert.not_equal! a.object_id, result_actual.object_id
  end

  def test_array_reject_bang args, assert
    a = [1, 2, 3, 4, 5, 6]
    result_expected = a.reject do |i| i.even? end
    result_actual = Array.reject! a do |i| i.even? end
    assert.equal! result_expected, result_actual
    assert.equal! a.object_id, result_actual.object_id
  end

  def test_array_select args, assert
    a = [1, 2, 3, 4, 5, 6]
    result_expected = a.select do |i| i.even? end
    result_actual = Array.select a do |i| i.even? end
    assert.equal! result_expected, result_actual
    assert.not_equal! a.object_id, result_actual.object_id
  end

  def test_array_select_bang args, assert
    a = [1, 2, 3, 4, 5, 6]
    result_expected = a.select do |i| i.even? end
    result_actual = Array.select! a do |i| i.even? end
    assert.equal! result_expected, result_actual
    assert.equal! a.object_id, result_actual.object_id
  end

  def test_array_find_all args, assert
    a = [1, 2, 3, 4, 5, 6]
    result_expected = a.find_all do |i| i.even? end
    result_actual = Array.find_all a do |i| i.even? end
    assert.equal! result_expected, result_actual
    assert.not_equal! a.object_id, result_actual.object_id
  end

  def test_array_compact args, assert
    a = [1, nil, 3, false, 5, 6]
    result_expected = a.compact do |i| i.even? end
    result_actual = Array.compact a do |i| i.even? end
    assert.equal! result_expected, result_actual
    assert.not_equal! a.object_id, result_actual.object_id
  end

  def test_array_compact_bang args, assert
    a = 100.map { |i| i }.map { |i| i.even? ? i : nil }
    result_expected = a.compact do |i| i.even? end
    result_actual = Array.compact! a do |i| i.even? end
    assert.equal! result_expected, result_actual
    assert.equal! a.object_id, result_actual.object_id
  end

  def test_filter_map args, assert
    a = [1, 2, 3, 4, 5, 6]
    result_expected = a.filter_map do |i| i.even? ? i * 2 : nil end
    result_actual = Array.filter_map a do |i| i.even? ? i * 2 : nil end
    assert.equal! result_expected, result_actual
    assert.not_equal! a.object_id, result_actual.object_id
  end

  def test_flat_map args, assert
    a = 100.map.each_slice(2).to_a
    result_expected = a.flat_map do |i| i end
    result_actual = Array.flat_map a do |i| i end
    assert.equal! result_expected, result_actual
    assert.not_equal! a.object_id, result_actual.object_id
  end

  def test_all args, assert
    a = 100.map { |i| i * 2 }.to_a
    result_expected = a.all? do |i| i.even? end
    result_actual = Array.all? a do |i| i.even? end
    assert.equal! result_expected, result_actual
    assert.not_equal! a.object_id, result_actual.object_id
  end

  def test_array_each args, assert
    a = [1, 2, 3, 4, 5, 6]
    result_expected = []
    a.each do |i| result_expected << i end
    result_actual = []
    Array.each a do |i| result_actual << i end
    assert.equal! result_expected, result_actual

    a = [[1, 2], [3, 4], [5, 6]]
    result_expected = []
    a.each do |x, y| result_expected << x + y end
    result_actual = []
    Array.each a do |x, y| result_actual << x + y end
    assert.equal! result_expected, result_actual

    a = [1, 2, 3, 4, 5, 6]
    result_expected = []
    a.each_with_index do |n, i| result_expected << n - i end
    result_actual = []
    Array.each_with_index a do |n, i| result_actual << n - i end
    assert.equal! result_expected, result_actual

    a = [[1, 2], [3, 4], [5, 6]]
    result_expected = []
    a.each_with_index do |(x, y), i| result_expected << x + y + i end
    result_actual = []
    Array.each_with_index a do |(x, y), i| result_actual << x + y + i end
    assert.equal! result_expected, result_actual
  end

  def test_zz_bench args, assert
    ary_numbers = 100.map { |i| i }.reverse.to_a
    ary_even_numbers = 1000.map { |i| 2 }.to_a
    ary_odd_numbers = 1000.map { |i| 3 }.to_a
    ary_compact = 100.map { |i| i }.map { |i| i.even? ? i : nil }
    ary_flat_map = 100.map.each_slice(2).to_a
    hash_even_numbers = 1000.map { |i| [i, 2] }.to_h
    hash_odd_numbers = 1000.map { |i| [i, 3] }.to_h

    functions = [
      { target: Array, name: :map,        ary: ary_numbers,       m: proc { |i| i / 2 } },
      { target: Array, name: :map!,       ary: ary_numbers,       m: proc { |i| i / 2 } },
      { target: Array, name: :reject,     ary: ary_numbers,       m: proc { |i| i.even? } },
      { target: Array, name: :all?,       ary: ary_even_numbers,  m: proc { |i| i.even? } },
      { target: Array, name: :any?,       ary: ary_odd_numbers,   m: proc { |i| i.even? } },
      { target: Array, name: :reject!,    ary: ary_numbers,       m: proc { |i| i.even? } },
      { target: Array, name: :find_all,   ary: ary_numbers,       m: proc { |i| i.even? } },
      { target: Array, name: :select,     ary: ary_numbers,       m: proc { |i| i.even? } },
      { target: Array, name: :select!,    ary: ary_numbers,       m: proc { |i| i.even? } },
      { target: Array, name: :filter_map, ary: ary_numbers,       m: proc { |i| i.even? ? i * 2 : nil } },
      { target: Array, name: :compact,    ary: ary_compact },
      { target: Array, name: :compact!,   ary: ary_compact },
      { target: Hash,  name: :all?,       ary: hash_even_numbers, m: proc { |k, v| v.even? } },
      { target: Hash,  name: :any?,       ary: hash_odd_numbers,  m: proc { |k, v| v.even? } },
    ]

    functions.each do |fh|
      h = {
        iterations: 5000,
      }

      self_numbers = fh.ary.dup
      class_numbers = fh.ary.dup

      h["self_#{fh[:target]}_#{fh[:name]}".to_sym] = -> () {
        self_numbers.send(fh[:name], &fh[:m])
      }

      h["class_#{fh[:target]}_#{fh[:name]}".to_sym] = -> () {
        fh[:target].send(fh[:name], class_numbers, &fh[:m])
      }

      results = GTK.benchmark(**h)
      assert.true! results.first_place.name.to_s.start_with?("class_"), "Class method #{fh[:name]} on #{fh[:target]} is faster"
    end

    self_numbers = ary_numbers.dup
    class_numbers = ary_numbers.dup
    results = GTK.benchmark iterations: 5000,
                            self_each: -> () { self_numbers.each { |i| i } },
                            class_each: -> () { Array.each(class_numbers) { |i| i } }

    self_flat_map = ary_flat_map.dup
    class_flat_map = ary_flat_map.dup
    results = GTK.benchmark iterations: 5000,
                            self_flat_map: -> () { self_flat_map.flat_map { |i| i } },
                            class_flat_map: -> () { Array.flat_map(class_flat_map) { |i| i } }

    assert.true! results.first_place.name.to_s.start_with?("class_"), "Class method each is faster"
  end

```

### Unit Tests - eval_hash_tests.rb
```ruby
  # ./samples/10_advanced_debugging/03_unit_tests/eval_hash_tests.rb
  def assert_hash assert, hash_or_string, expected
    h_to_s = if hash_or_string.is_a? String
               hash_or_string
             else
               hash_or_string.to_s
             end

    begin
      result = GTK::Codegen.eval_hash h_to_s
    rescue Exception => e
      result = e
    end
    if expected.is_a? Proc
      expected.call(result, assert)
    else
      assert.equal! result, expected
    end
  end

  def test_empty_hash args, assert
    assert_hash(assert, {}, {})
  end

  def test_allowed_node_types args, assert
    assert_hash(assert,
                {
                  node_hash: { },
                  node_nil: nil,
                  node_int: 1,
                  node_float: 10.5,
                  node_str: "string",
                  node_sym: :symbol,
                  node_true: true,
                  node_false: false,
                  node_array: [1, 2, 3],
                },
                {
                  node_hash: { },
                  node_nil: nil,
                  node_int: 1,
                  node_float: 10.5,
                  node_str: "string",
                  node_sym: :symbol,
                  node_true: true,
                  node_false: false,
                  node_array: [1, 2, 3],
                })
  end

  def test_args_state args, assert
    args.state.player.x ||= 100
    args.state.player.y ||= 200
    args.state.enemies ||= [
      { id: :a, x: 100, y: 100, w: 2, h: 3.0 },
      { id: :b, x: 100, y: 100, w: 2, h: 3.0 },
      { id: :c, x: 100, y: 100, w: 2, h: 3.0 },
      { id: :d, x: 100, y: 100, w: 2, h: 3.0 }
    ]

    assert_hash assert, args.state, ->(result, assert) {
      assert.true! args.state.as_hash.to_s, result.to_s
    }
  end

  def test_malicious_hash args, assert
    s = "{}; def malicious(args); end;"
    assert_hash assert, s, ->(result, assert) {
      assert.true! result.message.include?("NODE_DEF")
    }
  end

  def test_malicious_lvar_hash args, assert
    s = "a = 12; {};"
    assert_hash assert, s, ->(result, assert) {
      assert.true! result.message.include?("NODE_ASGN")
    }
  end

```

### Unit Tests - exception_raising_tests.rb
```ruby
  # ./samples/10_advanced_debugging/03_unit_tests/exception_raising_tests.rb
  begin :shared
    class ExceptionalClass
      def initialize exception_to_throw = nil
        raise exception_to_throw if exception_to_throw
      end
    end
  end

  def test_exception_in_newing_object args, assert
    begin
      ExceptionalClass.new TypeError
      raise "Exception wasn't thrown!"
    rescue Exception => e
      assert.equal! e.class, TypeError, "Exceptions within constructor should be retained."
    end
  end

```

### Unit Tests - fn_tests.rb
```ruby
  # ./samples/10_advanced_debugging/03_unit_tests/fn_tests.rb
  def infinity
    1 / 0
  end

  def neg_infinity
    -1 / 0
  end

  def nan
    0.0 / 0
  end

  def test_add args, assert
    assert.equal! (args.fn.add), 0
    assert.equal! (args.fn.+), 0
    assert.equal! (args.fn.+ 1, 2, 3), 6
    assert.equal! (args.fn.+ 0), 0
    assert.equal! (args.fn.+ 0, nil), 0
    assert.equal! (args.fn.+ 0, nan), nil
    assert.equal! (args.fn.+ 0, nil, infinity), nil
    assert.equal! (args.fn.+ [1, 2, 3, [4, 5, 6]]), 21
    assert.equal! (args.fn.+ [nil, [4, 5, 6]]), 15
  end

  def test_sub args, assert
    neg_infinity = infinity * -1
    assert.equal! (args.fn.+), 0
    assert.equal! (args.fn.- 1, 2, 3), -4
    assert.equal! (args.fn.- 4), -4
    assert.equal! (args.fn.- 4, nan), nil
    assert.equal! (args.fn.- 0, nil), 0
    assert.equal! (args.fn.- 0, nil, infinity), nil
    assert.equal! (args.fn.- [0, 1, 2, 3, [4, 5, 6]]), -21
    assert.equal! (args.fn.- [nil, 0, [4, 5, 6]]), -15
  end

  def test_div args, assert
    assert.equal! (args.fn.div), 1
    assert.equal! (args.fn./), 1
    assert.equal! (args.fn./ 6, 3), 2
    assert.equal! (args.fn./ 6, infinity), nil
    assert.equal! (args.fn./ 6, nan), nil
    assert.equal! (args.fn./ infinity), nil
    assert.equal! (args.fn./ 0), nil
    assert.equal! (args.fn./ 6, [3]), 2
  end

  def test_idiv args, assert
    assert.equal! (args.fn.idiv), 1
    assert.equal! (args.fn.idiv 7, 3), 2
    assert.equal! (args.fn.idiv 6, infinity), nil
    assert.equal! (args.fn.idiv 6, nan), nil
    assert.equal! (args.fn.idiv infinity), nil
    assert.equal! (args.fn.idiv 0), nil
    assert.equal! (args.fn.idiv 7, [3]), 2
  end

  def test_mul args, assert
    assert.equal! (args.fn.mul), 1
    assert.equal! (args.fn.*), 1
    assert.equal! (args.fn.* 7, 3), 21
    assert.equal! (args.fn.* 6, nan), nil
    assert.equal! (args.fn.* 6, infinity), nil
    assert.equal! (args.fn.* infinity), nil
    assert.equal! (args.fn.* 0), 0
    assert.equal! (args.fn.* 7, [3]), 21
  end

  def test_acopy args, assert
    orig  = [1, 2, 3]
    clone = args.fn.acopy orig
    assert.equal! clone, [1, 2, 3]
    assert.equal! clone, orig
    assert.not_equal! clone.object_id, orig.object_id
  end

  def test_aget args, assert
    assert.equal! (args.fn.aget [:a, :b, :c], 1), :b
    assert.equal! (args.fn.aget [:a, :b, :c], nil), nil
    assert.equal! (args.fn.aget nil, 1), nil
  end

  def test_alength args, assert
    assert.equal! (args.fn.alength [:a, :b, :c]), 3
    assert.equal! (args.fn.alength nil), nil
  end

  def test_amap args, assert
    inc = lambda { |i| i + 1 }
    ary = [1, 2, 3]
    assert.equal! (args.fn.amap ary, inc), [2, 3, 4]
    assert.equal! (args.fn.amap nil, inc), nil
    assert.equal! (args.fn.amap ary, nil), nil
    assert.equal! (args.fn.amap ary, inc).class, Array
  end

  def test_and args, assert
    assert.equal! (args.fn.and 1, 2, 3, 4), 4
    assert.equal! (args.fn.and 1, 2, nil, 4), nil
    assert.equal! (args.fn.and), true
  end

  def test_or args, assert
    assert.equal! (args.fn.or 1, 2, 3, 4), 1
    assert.equal! (args.fn.or 1, 2, nil, 4), 1
    assert.equal! (args.fn.or), nil
    assert.equal! (args.fn.or nil, nil, false, 5, 10), 5
  end

  def test_eq_eq args, assert
    assert.equal! (args.fn.eq?), true
    assert.equal! (args.fn.eq? 1, 0), false
    assert.equal! (args.fn.eq? 1, 1, 1), true
    assert.equal! (args.fn.== 1, 1, 1), true
    assert.equal! (args.fn.== nil, nil), true
  end

  def test_apply args, assert
    assert.equal! (args.fn.and [nil, nil, nil]), [nil, nil, nil]
    assert.equal! (args.fn.apply [nil, nil, nil], args.fn.method(:and)), nil
    and_lambda = lambda {|*xs| args.fn.and(*xs)}
    assert.equal! (args.fn.apply [nil, nil, nil], and_lambda), nil
  end

  def test_areduce args, assert
    assert.equal! (args.fn.areduce [1, 2, 3], 0, lambda { |i, a| i + a }), 6
  end

  def test_array_hash args, assert
    assert.equal! (args.fn.array_hash :a, 1, :b, 2), { a: 1, b: 2 }
    assert.equal! (args.fn.array_hash), { }
  end

```

### Unit Tests - gen_docs.rb
```ruby
  # ./samples/10_advanced_debugging/03_unit_tests/gen_docs.rb
  # ./dragonruby . --eval samples/10_advanced_debugging/03_unit_tests/gen_docs.rb --no-tick
  # OR
  # ./dragonruby ./samples/10_advanced_debugging/03_unit_tests --test gen_docs.rb
  Kernel.export_docs!

```

### Unit Tests - geometry_tests.rb
```ruby
  # ./samples/10_advanced_debugging/03_unit_tests/geometry_tests.rb
  begin :shared
    def primitive_representations x, y, w, h
      [
        [x, y, w, h],
        { x: x, y: y, w: w, h: h },
        RectForTest.new(x, y, w, h)
      ]
    end

    class RectForTest
      attr_sprite

      def initialize x, y, w, h
        @x = x
        @y = y
        @w = w
        @h = h
      end

      def to_s
        "RectForTest: #{[x, y, w, h]}"
      end
    end
  end

  begin :intersect_rect?
    def test_intersect_rect_point args, assert
      assert.true! [16, 13].intersect_rect?([13, 12, 4, 4]), "point intersects with rect."
    end

    def test_intersect_rect args, assert
      intersecting = primitive_representations(0, 0, 100, 100) +
                     primitive_representations(20, 20, 20, 20)

      intersecting.product(intersecting).each do |rect_one, rect_two|
        assert.true! rect_one.intersect_rect?(rect_two),
                     "intersect_rect? assertion failed for #{rect_one}, #{rect_two} (expected true)."
      end

      not_intersecting = [
        [ 0, 0, 5, 5],
        { x: 10, y: 10, w: 5, h: 5 },
        RectForTest.new(20, 20, 5, 5)
      ]

      not_intersecting.product(not_intersecting)
        .reject { |rect_one, rect_two| rect_one == rect_two }
        .each do |rect_one, rect_two|
        assert.false! rect_one.intersect_rect?(rect_two),
                      "intersect_rect? assertion failed for #{rect_one}, #{rect_two} (expected false)."
      end
    end
  end

  begin :inside_rect?
    def assert_inside_rect outer: nil, inner: nil, expected: nil, assert: nil
      assert.true! inner.inside_rect?(outer) == expected,
                   "inside_rect? assertion failed for outer: #{outer} inner: #{inner} (expected #{expected})."
    end

    def test_inside_rect args, assert
      outer_rects = primitive_representations(0, 0, 10, 10)
      inner_rects = primitive_representations(1, 1, 5, 5)
      primitive_representations(0, 0, 10, 10).product(primitive_representations(1, 1, 5, 5))
        .each do |outer, inner|
        assert_inside_rect outer: outer, inner: inner,
                           expected: true, assert: assert
      end
    end
  end

  begin :angle_to
    def test_angle_to args, assert
      origins = primitive_representations(0, 0, 0, 0)
      rights = primitive_representations(1, 0, 0, 0)
      aboves = primitive_representations(0, 1, 0, 0)

      origins.product(aboves).each do |origin, above|
        assert.equal! origin.angle_to(above), 90,
                      "A point directly above should be 90 degrees."

        assert.equal! above.angle_from(origin), 90,
                      "A point coming from above should be 90 degrees."
      end

      origins.product(rights).each do |origin, right|
        assert.equal! origin.angle_to(right) % 360, 0,
                      "A point directly to the right should be 0 degrees."

        assert.equal! right.angle_from(origin) % 360, 0,
                      "A point coming from the right should be 0 degrees."

      end
    end
  end

  begin :scale_rect
    def test_scale_rect args, assert
      assert.equal! [0, 0, 100, 100].scale_rect(0.5, 0.5),
                    [25.0, 25.0, 50.0, 50.0]

      assert.equal! [0, 0, 100, 100].scale_rect(0.5),
                    [0.0, 0.0, 50.0, 50.0]

      assert.equal! [0, 0, 100, 100].scale_rect_extended(percentage_x: 0.5, percentage_y: 0.5, anchor_x: 0.5, anchor_y: 0.5),
                    [25.0, 25.0, 50.0, 50.0]

      assert.equal! [0, 0, 100, 100].scale_rect_extended(percentage_x: 0.5, percentage_y: 0.5, anchor_x: 0, anchor_y: 0),
                    [0.0, 0.0, 50.0, 50.0]
    end
  end


```

### Unit Tests - http_tests.rb
```ruby
  # ./samples/10_advanced_debugging/03_unit_tests/http_tests.rb
  def try_assert_or_schedule args, assert
    if $result[:complete]
      log_info "Request completed! Verifying."
      if $result[:http_response_code] != 200
        log_info "The request yielded a result of #{$result[:http_response_code]} instead of 200."
        exit
      end
      log_info ":try_assert_or_schedule succeeded!"
    else
      GTK.schedule_callback Kernel.tick_count + 10 do
        try_assert_or_schedule args, assert
      end
    end
  end

  def test_http args, assert
    $result = GTK.http_get 'http://dragonruby.org'
    try_assert_or_schedule args, assert
  end

```

### Unit Tests - input_emulation_tests.rb
```ruby
  # ./samples/10_advanced_debugging/03_unit_tests/input_emulation_tests.rb
  def test_keyboard args, assert
    args.inputs.keyboard.key_down.i = true
    assert.true! args.inputs.keyboard.truthy_keys.include?(:i)
  end

```

### Unit Tests - nil_coercion_tests.rb
```ruby
  # ./samples/10_advanced_debugging/03_unit_tests/nil_coercion_tests.rb
  # numbers
  def test_open_entity_add_number args, assert
    assert.nil! args.state.i_value
    args.state.i_value += 5
    assert.equal! args.state.i_value, 5

    assert.nil! args.state.f_value
    args.state.f_value += 5.5
    assert.equal! args.state.f_value, 5.5
  end

  def test_open_entity_subtract_number args, assert
    assert.nil! args.state.i_value
    args.state.i_value -= 5
    assert.equal! args.state.i_value, -5

    assert.nil! args.state.f_value
    args.state.f_value -= 5.5
    assert.equal! args.state.f_value, -5.5
  end

  def test_open_entity_multiply_number args, assert
    assert.nil! args.state.i_value
    args.state.i_value *= 5
    assert.equal! args.state.i_value, 0

    assert.nil! args.state.f_value
    args.state.f_value *= 5.5
    assert.equal! args.state.f_value, 0
  end

  def test_open_entity_divide_number args, assert
    assert.nil! args.state.i_value
    args.state.i_value /= 5
    assert.equal! args.state.i_value, 0

    assert.nil! args.state.f_value
    args.state.f_value /= 5.5
    assert.equal! args.state.f_value, 0
  end

  # array
  def test_open_entity_add_array args, assert
    assert.nil! args.state.values
    args.state.values += [:a, :b, :c]
    assert.equal! args.state.values, [:a, :b, :c]
  end

  def test_open_entity_subtract_array args, assert
    assert.nil! args.state.values
    args.state.values -= [:a, :b, :c]
    assert.equal! args.state.values, []
  end

  def test_open_entity_shovel_array args, assert
    assert.nil! args.state.values
    args.state.values << :a
    assert.equal! args.state.values, [:a]
  end

  def test_open_entity_enumerate args, assert
    assert.nil! args.state.values
    args.state.values = args.state.values.map_with_index { |i| i }
    assert.equal! args.state.values, []

    assert.nil! args.state.values_2
    args.state.values_2 = args.state.values_2.map { |i| i }
    assert.equal! args.state.values_2, []

    assert.nil! args.state.values_3
    args.state.values_3 = args.state.values_3.flat_map { |i| i }
    assert.equal! args.state.values_3, []
  end

  # hashes
  def test_open_entity_indexer args, assert
    GTK::Entity.__reset_id__!
    assert.nil! args.state.values
    args.state.values[:test] = :value
    assert.equal! args.state.values.to_s, { entity_id: 1, entity_name: :values, entity_keys_by_ref: {}, test: :value }.to_s
  end

  # bug
  def test_open_entity_nil_bug args, assert
    GTK::Entity.__reset_id__!
    args.state.foo.a
    args.state.foo.b
    @hello[:foobar]
    assert.nil! args.state.foo.a, "a was not nil."
    # the line below fails
    # assert.nil! args.state.foo.b, "b was not nil."
  end

```

### Unit Tests - numeric_rand_tests.rb
```ruby
  # ./samples/10_advanced_debugging/03_unit_tests/numeric_rand_tests.rb
  def test_randomize_int args, assert
    srand(100)
    assert.equal!(10.randomize(:ratio).round(5),         5.43405)
    assert.equal!(10.randomize(:ratio).round(5),         6.71156)
    assert.equal!(10.randomize(:ratio).round(5),         2.78369)
    assert.equal!(10.randomize(:ratio).round(5),         4.12046)
    assert.equal!(10.randomize(:sign),                   10)
    assert.equal!(10.randomize(:sign),                  -10)
    assert.equal!(10.randomize(:sign),                  -10)
    assert.equal!(10.randomize(:sign),                   10)
    assert.equal!(10.randomize(:ratio, :sign).round(5),  1.56711)
    assert.equal!(10.randomize(:ratio, :sign).round(5),  1.86467)
    assert.equal!(10.randomize(:ratio, :sign).round(5), -2.10108)
    assert.equal!(10.randomize(:ratio, :sign).round(5), -4.52740)
    assert.equal!(10.randomize(:int, :sign),             0)
    assert.equal!(10.randomize(:int, :sign),            -3)
    assert.equal!(10.randomize(:int, :sign),            -7)
    assert.equal!(10.randomize(:int, :sign),             6)
    assert.equal!(10.randomize(:int),                    0)
    assert.equal!(10.randomize(:int),                    1)
    assert.equal!(10.randomize(:int),                    9)
    assert.equal!(10.randomize(:int),                    9)
  end

  def test_randomize_float args, assert
    srand(100)
    assert.equal!(10.0.randomize(:ratio).round(5),         5.43405)
    assert.equal!(10.0.randomize(:ratio).round(5),         6.71156)
    assert.equal!(10.0.randomize(:ratio).round(5),         2.78369)
    assert.equal!(10.0.randomize(:ratio).round(5),         4.12046)
    assert.equal!(10.4.randomize(:sign),                   10.4)
    assert.equal!(10.4.randomize(:sign),                  -10.4)
    assert.equal!(10.4.randomize(:sign),                  -10.4)
    assert.equal!(10.4.randomize(:sign),                   10.4)
    assert.equal!(10.0.randomize(:ratio, :sign).round(5),  1.56711)
    assert.equal!(10.0.randomize(:ratio, :sign).round(5),  1.86467)
    assert.equal!(10.0.randomize(:ratio, :sign).round(5), -2.10108)
    assert.equal!(10.0.randomize(:ratio, :sign).round(5), -4.52740)
    assert.equal!(10.4.randomize(:int, :sign),             0)
    assert.equal!(10.4.randomize(:int, :sign),            -3)
    assert.equal!(10.4.randomize(:int, :sign),            -7)
    assert.equal!(10.4.randomize(:int, :sign),             6)
    assert.equal!(10.4.randomize(:int),                    0)
    assert.equal!(10.4.randomize(:int),                    1)
    assert.equal!(10.4.randomize(:int),                    9)
    assert.equal!(10.4.randomize(:int),                    9)
  end

  def test_ratio_float_alias args, assert
    srand(100)
    assert.equal!(10.0.randomize(:float).round(5),         5.43405)
    assert.equal!(10.0.randomize(:float).round(5),         6.71156)
    assert.equal!(10.0.randomize(:float).round(5),         2.78369)
    assert.equal!(10.0.randomize(:float).round(5),         4.12046)
    assert.equal!(10.4.randomize(:sign),                   10.4)
    assert.equal!(10.4.randomize(:sign),                  -10.4)
    assert.equal!(10.4.randomize(:sign),                  -10.4)
    assert.equal!(10.4.randomize(:sign),                   10.4)
    assert.equal!(10.0.randomize(:float, :sign).round(5),  1.56711)
    assert.equal!(10.0.randomize(:float, :sign).round(5),  1.86467)
    assert.equal!(10.0.randomize(:float, :sign).round(5), -2.10108)
    assert.equal!(10.0.randomize(:float, :sign).round(5), -4.52740)
    assert.equal!(10.4.randomize(:int, :sign),             0)
    assert.equal!(10.4.randomize(:int, :sign),            -3)
    assert.equal!(10.4.randomize(:int, :sign),            -7)
    assert.equal!(10.4.randomize(:int, :sign),             6)
    assert.equal!(10.4.randomize(:int),                    0)
    assert.equal!(10.4.randomize(:int),                    1)
    assert.equal!(10.4.randomize(:int),                    9)
    assert.equal!(10.4.randomize(:int),                    9)

    srand(100)
    assert.equal!(10.randomize(:float).round(5),         5.43405)
    assert.equal!(10.randomize(:float).round(5),         6.71156)
    assert.equal!(10.randomize(:float).round(5),         2.78369)
    assert.equal!(10.randomize(:float).round(5),         4.12046)
    assert.equal!(10.randomize(:sign),                   10)
    assert.equal!(10.randomize(:sign),                  -10)
    assert.equal!(10.randomize(:sign),                  -10)
    assert.equal!(10.randomize(:sign),                   10)
    assert.equal!(10.randomize(:float, :sign).round(5),  1.56711)
    assert.equal!(10.randomize(:float, :sign).round(5),  1.86467)
    assert.equal!(10.randomize(:float, :sign).round(5), -2.10108)
    assert.equal!(10.randomize(:float, :sign).round(5), -4.52740)
    assert.equal!(10.randomize(:int, :sign),             0)
    assert.equal!(10.randomize(:int, :sign),            -3)
    assert.equal!(10.randomize(:int, :sign),            -7)
    assert.equal!(10.randomize(:int, :sign),             6)
    assert.equal!(10.randomize(:int),                    0)
    assert.equal!(10.randomize(:int),                    1)
    assert.equal!(10.randomize(:int),                    9)
    assert.equal!(10.randomize(:int),                    9)
  end

  def test_numeric_instance_rand_sign args, assert
    srand(100)
    assert.equal!(10.rand(:sign), -10)
    assert.equal!(10.rand(:sign), -10)
    assert.equal!(10.rand(:sign),  10)
    assert.equal!(10.rand(:sign),  10)
    assert.equal!(10.rand(:sign),  10)
    assert.equal!(10.4.rand(:sign), -10.4)
    assert.equal!(10.4.rand(:sign), -10.4)
    assert.equal!(10.4.rand(:sign), 10.4)
    assert.equal!(10.4.rand(:sign), 10.4)
    assert.equal!(10.4.rand(:sign), 10.4)
  end

  def test_numeric_self_rand_vs_instance_rand args, assert
    value_comparison = [
      {
        name: "rand for integer",
        klass:    -> { Numeric.rand(10) },
        instance: -> { 10.rand }
      },
      {
        name: "rand for integer from float",
        klass:    -> { Numeric.rand(10) },
        instance: -> { 10.0.rand(:int) }
      },
      {
        name: "rand for float",
        klass:    -> { Numeric.rand(10.0).round(5) },
        instance: -> { 10.0.rand.round(5) }
      },
      {
        name: "rand for float from int",
        klass:    -> { Numeric.rand(10.0).round(5) },
        instance: -> { 10.rand(:ratio).round(5) }
      },
      {
        name: "rand for float from int",
        klass:    -> { Numeric.rand(10.0).round(5) },
        instance: -> { 10.rand(:float).round(5) }
      },
      {
        name: "rand int range (sign)",
        klass:    -> { Numeric.rand(-10..10) },
        instance: -> { 10.rand(:int, :sign) }
      },
      {
        name: "rand int range from float (sign)",
        klass:    -> { Numeric.rand(-10..10) },
        instance: -> { 10.0.rand(:int, :sign) }
      },
      {
        name: "rand ratio range (sign)",
        klass:    -> { Numeric.rand(-10.0..10.0) },
        instance: -> { 10.0.rand(:float, :sign) }
      },
      {
        name: "rand ratio range from int (sign)",
        klass:    -> { Numeric.rand(-10.0..10.0) },
        instance: -> { 10.rand(:float, :sign) }
      },
      {
        name: "rand ratio range (sign)",
        klass:    -> { Numeric.rand(-10.0..10.0) },
        instance: -> { 10.0.rand(:ratio, :sign) }
      },
      {
        name: "rand ratio range from int (sign)",
        klass:    -> { Numeric.rand(-10.0..10.0) },
        instance: -> { 10.rand(:ratio, :sign) }
      },
    ]

    value_comparison.each do |h|
      srand(100)
      klass_value = h.klass.call
      srand(100)
      instance_value = h.instance.call
      assert.equal!(klass_value, instance_value, "comparison label: #{h.name}")
    end
  end

```

### Unit Tests - object_to_primitive_tests.rb
```ruby
  # ./samples/10_advanced_debugging/03_unit_tests/object_to_primitive_tests.rb
  class PlayerSpriteForTest
  end

  def test_array_to_sprite args, assert
    array = [[0, 0, 100, 100, "test.png"]].sprites
    puts "No exception was thrown. Sweet!"
  end

  def test_class_to_sprite args, assert
    array = [PlayerSprite.new].sprites
    assert.true! array.first.is_a?(PlayerSprite)
    puts "No exception was thrown. Sweet!"
  end

```

### Unit Tests - parsing_tests.rb
```ruby
  # ./samples/10_advanced_debugging/03_unit_tests/parsing_tests.rb
  def test_parse_json args, assert
    result = GTK.parse_json '{ "name": "John Doe", "aliases": ["JD"] }'
    assert.equal! result, { "name"=>"John Doe", "aliases"=>["JD"] }, "Parsing JSON failed."
  end

  def test_parse_xml args, assert
    result = GTK.parse_xml <<-S
  <Person id="100">
    <Name>John Doe</Name>
  </Person>
  S

   expected = {:type=>:element,
               :name=>nil,
               :children=>[{:type=>:element,
                            :name=>"Person",
                            :children=>[{:type=>:element,
                                         :name=>"Name",
                                         :children=>[{:type=>:content,
                                                      :data=>"John Doe"}]}],
                            :attributes=>{"id"=>"100"}}]}

   assert.equal! result, expected, "Parsing xml failed."
  end

```

### Unit Tests - pretty_format_tests.rb
```ruby
  # ./samples/10_advanced_debugging/03_unit_tests/pretty_format_tests.rb
  def H opts
    opts
  end

  def A *opts
    opts
  end

  def assert_format args, assert, hash, expected
    actual = args.fn.pretty_format hash
    assert.are_equal! actual, expected
  end

  def test_pretty_print args, assert
    # =============================
    # hash with single value
    # =============================
    input = (H first_name: "John")
    expected = <<-S
  {:first_name "John"}
  S
    (assert_format args, assert, input, expected)

    # =============================
    # hash with two values
    # =============================
    input = (H first_name: "John", last_name: "Smith")
    expected = <<-S
  {:first_name "John"
   :last_name "Smith"}
  S

    (assert_format args, assert, input, expected)

    # =============================
    # hash with inner hash
    # =============================
    input = (H first_name: "John",
               last_name: "Smith",
               middle_initial: "I",
               so: (H first_name: "Pocahontas",
                      last_name: "Tsenacommacah"),
               friends: (A (H first_name: "Side", last_name: "Kick"),
                           (H first_name: "Tim", last_name: "Wizard")))
    expected = <<-S
  {:first_name "John"
   :last_name "Smith"
   :middle_initial "I"
   :so {:first_name "Pocahontas"
        :last_name "Tsenacommacah"}
   :friends [{:first_name "Side"
              :last_name "Kick"}
             {:first_name "Tim"
              :last_name "Wizard"}]}
  S

    (assert_format args, assert, input, expected)

    # =============================
    # array with one value
    # =============================
    input = (A 1)
    expected = <<-S
  [1]
  S
    (assert_format args, assert, input, expected)

    # =============================
    # array with multiple values
    # =============================
    input = (A 1, 2, 3)
    expected = <<-S
  [1
   2
   3]
  S
    (assert_format args, assert, input, expected)

    # =============================
    # array with multiple values hashes
    # =============================
    input = (A (H first_name: "Side", last_name: "Kick"),
               (H first_name: "Tim", last_name: "Wizard"))
    expected = <<-S
  [{:first_name "Side"
    :last_name "Kick"}
   {:first_name "Tim"
    :last_name "Wizard"}]
  S

    (assert_format args, assert, input, expected)
  end

  def test_nested_nested args, assert
    # =============================
    # nested array in nested hash
    # =============================
    input = (H type: :root,
               text: "Root",
               children: (A (H level: 1,
                               text: "Level 1",
                               children: (A (H level: 2,
                                               text: "Level 2",
                                               children: [])))))

    expected = <<-S
  {:type :root
   :text "Root"
   :children [{:level 1
               :text "Level 1"
               :children [{:level 2
                           :text "Level 2"
                           :children []}]}]}

  S

    (assert_format args, assert, input, expected)
  end

  def test_scene args, assert
    script = <<-S
  * Scene 1
  ** Narrator
  They say happy endings don't exist.
  ** Narrator
  They say true love is a lie.
  S
    input = parse_org args, script
    puts (args.fn.pretty_format input)
  end

```

### Unit Tests - require_tests.rb
```ruby
  # ./samples/10_advanced_debugging/03_unit_tests/require_tests.rb
  def write_src path, src
    GTK.write_file path, src
  end

  write_src 'app/unit_testing_game.rb', <<-S
  module UnitTesting
    class Game
    end
  end
  S

  write_src 'lib/unit_testing_lib.rb', <<-S
  module UnitTesting
    class Lib
    end
  end
  S

  write_src 'app/nested/unit_testing_nested.rb', <<-S
  module UnitTesting
    class Nested
    end
  end
  S

  require 'app/unit_testing_game.rb'
  require 'app/nested/unit_testing_nested.rb'
  require 'lib/unit_testing_lib.rb'

  def test_require args, assert
    UnitTesting::Game.new
    UnitTesting::Lib.new
    UnitTesting::Nested.new
    GTK.exec 'rm ./mygame/app/unit_testing_game.rb'
    GTK.exec 'rm ./mygame/app/nested/unit_testing_nested.rb'
    GTK.exec 'rm ./mygame/lib/unit_testing_lib.rb'
    assert.ok!
  end

```

### Unit Tests - serialize_deserialize_tests.rb
```ruby
  # ./samples/10_advanced_debugging/03_unit_tests/serialize_deserialize_tests.rb
  def assert_hash_strings! assert, string_1, string_2
    Kernel.eval("$assert_hash_string_1 = #{string_1}")
    Kernel.eval("$assert_hash_string_2 = #{string_2}")
    assert.equal! $assert_hash_string_1, $assert_hash_string_2
  end

  def test_serialize args, assert
    args.state.player_one = "test"
    result = GTK.serialize_state args.state
    assert_hash_strings! assert, result, "{:entity_id=>1, :entity_keys_by_ref=>{}, :tick_count=>-1, :player_one=>\"test\"}"

    GTK.write_file 'state.txt', ''
    result = GTK.serialize_state 'state.txt', args.state
    assert_hash_strings! assert, result, "{:entity_id=>1, :entity_keys_by_ref=>{}, :tick_count=>-1, :player_one=>\"test\"}"
  end

  def test_deserialize args, assert
    result = GTK.deserialize_state '{:entity_id=>3, :tick_count=>-1, :player_one=>"test"}'
    assert.equal! result.player_one, "test"

    GTK.write_file 'state.txt',  '{:entity_id=>3, :tick_count=>-1, :player_one=>"test"}'
    result = GTK.deserialize_state 'state.txt'
    assert.equal! result.player_one, "test"
  end

  def test_very_large_serialization args, assert
    GTK.write_file("logs/log.txt", "")
    size = 3000
    size.map_with_index do |i|
      args.state.send("k#{i}=".to_sym, i)
    end

    result = GTK.serialize_state args.state
    assert.true! $serialize_state_serialization_too_large
  end

  def test_strict_entity_serialization args, assert
    args.state.player_one = args.state.new_entity(:player, name: "Ryu")
    args.state.player_two = args.state.new_entity_strict(:player_strict, name: "Ken")

    serialized_state = GTK.serialize_state args.state
    assert_hash_strings! assert, serialized_state, '{:entity_id=>1, :entity_keys_by_ref=>{}, :tick_count=>-1, :player_one=>{:entity_id=>3, :entity_name=>:player, :entity_keys_by_ref=>{}, :entity_type=>:player, :created_at=>-1, :global_created_at=>-1, :name=>"Ryu"}, :player_two=>{:entity_id=>5, :entity_name=>:player_strict, :entity_type=>:player_strict, :created_at=>-1, :global_created_at_elapsed=>-1, :entity_strict=>true, :entity_keys_by_ref=>{}, :name=>"Ken"}}'

    deserialize_state = GTK.deserialize_state serialized_state

    assert.equal! args.state.player_one.name, deserialize_state.player_one.name
    assert.true! args.state.player_one.is_a? GTK::OpenEntity

    assert.equal! args.state.player_two.name, deserialize_state.player_two.name
    assert.true! args.state.player_two.is_a? GTK::StrictEntity
  end

  def test_strict_entity_serialization_with_nil args, assert
    args.state.player_one = args.state.new_entity(:player, name: "Ryu")
    args.state.player_two = args.state.new_entity_strict(:player_strict, name: "Ken", blood_type: nil)

    serialized_state = GTK.serialize_state args.state
    assert_hash_strings! assert, serialized_state, '{:entity_id=>1, :entity_keys_by_ref=>{}, :tick_count=>-1, :player_one=>{:entity_id=>3, :entity_name=>:player, :entity_keys_by_ref=>{}, :entity_type=>:player, :created_at=>-1, :global_created_at=>-1, :name=>"Ryu"}, :player_two=>{:entity_name=>:player_strict, :global_created_at_elapsed=>-1, :created_at=>-1, :blood_type=>nil, :name=>"Ken", :entity_type=>:player_strict, :entity_strict=>true, :entity_keys_by_ref=>{}, :entity_id=>4}}'

    deserialized_state = GTK.deserialize_state serialized_state

    assert.equal! args.state.player_one.name, deserialized_state.player_one.name
    assert.true! args.state.player_one.is_a? GTK::OpenEntity

    assert.equal! args.state.player_two.name, deserialized_state.player_two.name
    assert.equal! args.state.player_two.blood_type, deserialized_state.player_two.blood_type
    assert.equal! deserialized_state.player_two.blood_type, nil
    assert.true! args.state.player_two.is_a? GTK::StrictEntity

    deserialized_state.player_two.blood_type = :O
    assert.equal! deserialized_state.player_two.blood_type, :O
  end

  def test_multiple_strict_entities args, assert
    args.state.player = args.state.new_entity_strict(:player_one, name: "Ryu")
    args.state.enemy = args.state.new_entity_strict(:enemy, name: "Bison", other_property: 'extra mean')

    serialized_state = GTK.serialize_state args.state

    deserialized_state = GTK.deserialize_state serialized_state

    assert.equal! deserialized_state.player.name, "Ryu"
    assert.equal! deserialized_state.enemy.other_property, "extra mean"
  end

  def test_by_reference_state args, assert
    # TODO
    # args.state.a = args.state.new_entity(:person, name: "Jane Doe")
    # args.state.b = args.state.a
    # assert.equal! args.state.a.object_id, args.state.b.object_id
    # serialized_state = GTK.serialize_state args.state

    # deserialized_state = GTK.deserialize_state serialized_state
    # assert.equal! deserialized_state.a.object_id, deserialized_state.b.object_id
  end

  def test_by_reference_state_strict_entities args, assert
    args.state.strict_entity = args.state.new_entity_strict(:couple) do |e|
      e.one = args.state.new_entity_strict(:person, name: "Jane")
      e.two = e.one
    end
    assert.equal! args.state.strict_entity.one, args.state.strict_entity.two
    serialized_state = GTK.serialize_state args.state

    deserialized_state = GTK.deserialize_state serialized_state
    assert.equal! deserialized_state.strict_entity.one, deserialized_state.strict_entity.two
  end

  def test_serialization_does_not_mix_up_zero_and_true args, assert
    args.state.enemy.evil = true
    args.state.enemy.hp = 0
    serialized = GTK.serialize_state args.state.enemy

    deserialized = GTK.deserialize_state serialized

    assert.equal! deserialized.hp, 0,
                  "Value should have been deserialized as 0, but was #{deserialized.hp}"
    assert.equal! deserialized.evil, true,
                  "Value should have been deserialized as true, but was #{deserialized.evil}"
  end

```

### Unit Tests - state_serialization_experimental_tests.rb
```ruby
  # ./samples/10_advanced_debugging/03_unit_tests/state_serialization_experimental_tests.rb
  MAX_CODE_GEN_LENGTH = 50

  # NOTE: This is experimental/advanced stuff.
  def needs_partitioning? target
    target[:value].to_s.length > MAX_CODE_GEN_LENGTH
  end

  def partition target
    return [] unless needs_partitioning? target
    if target[:value].is_a? GTK::OpenEntity
      target[:value] = target[:value].hash
    end

    results = []
    idx = 0
    left, right = target[:value].partition do
      idx += 1
      idx.even?
    end
    left, right = Hash[left], Hash[right]
    left = { value: left }
    right = { value: right}
    [left, right]
  end

  def add_partition target, path, aggregate, final_result
    partitions = partition target
    partitions.each do |part|
      if needs_partitioning? part
        if part[:value].keys.length == 1
          first_key = part[:value].keys[0]
          new_part = { value: part[:value][first_key] }
          path.push first_key
          add_partition new_part, path, aggregate, final_result
          path.pop
        else
          add_partition part, path, aggregate, final_result
        end
      else
        final_result << { value: { __path__: [*path] } }
        final_result << { value: part[:value] }
      end
    end
  end

  def state_to_string state
    parts_queue = []
    final_queue = []
    add_partition({ value: state.hash },
                  [],
                  parts_queue,
                  final_queue)
    final_queue.reject {|i| i[:value].keys.length == 0}.map do |i|
      i[:value].to_s
    end.join("\n#==================================================#\n")
  end

  def state_from_string string
    Kernel.eval("$load_data = {}")
    lines = string.split("\n#==================================================#\n")
    lines.each do |l|
      puts "todo: #{l}"
    end

    GTK::OpenEntity.parse_from_hash $load_data
  end

  def test_save_and_load args, assert
    args.state.item_1.name = "Jane"
    string = state_to_string args.state
    state = state_from_string string
    assert.equal! args.state.item_1.name, state.item_1.name
  end

  def test_save_and_load_big args, assert
    size = 1000
    size.map_with_index do |i|
      args.state.send("k#{i}=".to_sym, i)
    end

    string = state_to_string args.state
    state = state_from_string string
    size.map_with_index do |i|
      assert.equal! args.state.send("k#{i}".to_sym), state.send("k#{i}".to_sym)
      assert.equal! args.state.send("k#{i}".to_sym), i
      assert.equal! state.send("k#{i}".to_sym), i
    end
  end

  def test_save_and_load_big_nested args, assert
    args.state.player_one.friend.nested_hash.k0 = 0
    args.state.player_one.friend.nested_hash.k1 = 1
    args.state.player_one.friend.nested_hash.k2 = 2
    args.state.player_one.friend.nested_hash.k3 = 3
    args.state.player_one.friend.nested_hash.k4 = 4
    args.state.player_one.friend.nested_hash.k5 = 5
    args.state.player_one.friend.nested_hash.k6 = 6
    args.state.player_one.friend.nested_hash.k7 = 7
    args.state.player_one.friend.nested_hash.k8 = 8
    args.state.player_one.friend.nested_hash.k9 = 9
    string = state_to_string args.state
    state = state_from_string string
  end

```

### Unit Tests - string_split_tests.rb
```ruby
  # ./samples/10_advanced_debugging/03_unit_tests/string_split_tests.rb
  def assert_string_split args, assert, entry
    desc = []
    desc << ""
    desc << "* Desc"
    desc << "  contents: #{entry.contents.inspect}"

    if entry.key?(:sep)
      desc << "  sep: #{entry.sep.inspect}"
    else
      desc << "  sep: not given"
    end

    if entry.key?(:limit)
      desc << "  limit: #{entry.limit.inspect}"
    else
      desc << "  limit: not given"
    end

    desc << "* Results"
    if entry.key?(:sep) && entry.key?(:limit)
      expected = entry.contents.split(entry.sep, entry.limit)
      actual = String.split(entry.contents, entry.sep, entry.limit)
      desc << "  String#split (baseline): #{expected}"
      desc << "  String::split (redone):  #{actual}"
      assert.equal! expected, actual, desc.join("\n")
    elsif entry.key?(:sep)
      expected = entry.contents.split(entry.sep)
      actual = String.split(entry.contents, entry.sep)
      desc << "  String#split (baseline): #{expected}"
      desc << "  String::split (redone):  #{actual}"
      assert.equal! expected, actual, desc.join("\n")
    else
      expected = entry.contents.split
      actual = String.split(entry.contents)
      desc << "  String#split (baseline): #{expected}"
      desc << "  String::split (redone):  #{actual}"
      assert.equal! expected, actual, desc.join("\n")
    end
  end

  def test_string_split_empty_entries args, assert
    [
      {
        contents: ",",
        sep: ","
      },
      {
        contents: "aaaaa,,aa,,,a",
        sep: ","
      },
      {
        contents: ",a",
        sep: ","
      },
      {
        contents: ",aaaa",
        sep: ","
      },
      {
        contents: ",a",
        sep: ",",
        limit: 2
      },
      {
        contents: "aaa,",
        sep: ",",
        limit: 1
      },
      {
        contents: ",,,,",
        sep: ","
      },
      {
        contents: "a,,b",
        sep: ",",
        limit: 2
      },
      {
        contents: ",a",
        sep: ",",
        limit: 2
      },
      {
        contents: "a,",
        sep: ",",
        limit: 1
      },
      {
        contents: "a,,,",
        sep: ",",
        limit: 2
      },
      {
        contents: ",,,,",
        sep: ",",
        limit: 2
      },
      {
        contents: "Flippy Flap,,,Start,Quit",
        sep: ",",
      },
    ].each do |h|
      assert_string_split args, assert, h
    end
  end

  def test_string_split args, assert
    [
      {
        contents: "Hello Beautiful World",
      },
      {
        contents: "one,two,three",
        sep: ","
      },
      {
        contents: "Hello Beautiful World",
        sep: " ",
        limit: 2
      },
      {
        contents: "one,,three",
        sep: ","
      },
      {
        contents: "hello",
        sep: ""
      },
      {
        contents: "1,2,3,4,5",
        sep: ",",
        limit: 3
      },
      {
        contents: "1,2,3,4,5",
        sep: ",",
        limit: 1
      },
      {
        contents: "1,2,3,4,5",
        sep: ",",
        limit: 0
      },
      {
        contents: "1,2,3,4,5",
        sep: ",",
        limit: -1
      },
      {
        contents: "",
        sep: ","
      },
      {
        contents: "846,360,25,50,orange,1,sprites/bricks/orange_brick.png,v",
        sep: ","
      },
      {
        contents: "hello",
      },
      {
        contents: "hello",
        sep: ","
      },
      {
        contents: "hello",
        sep: ""
      },
      {
        contents: "a,,b",
        sep: ","
      },
      {
        contents: "a,",
        sep: ","
      },
      {
        contents: "aaa,",
        sep: ",",
        limit: 2
      },
      {
        contents: "aaa,",
        sep: ",",
        limit: 0
      },
      {
        contents: "",
        sep: ",",
        limit: 2
      },
      {
        contents: "846,360,25,50,orange,1,sprites/bricks/orange_brick.png,v",
        sep: ",",
        limit: 2
      },
      {
        contents: "hello",
        sep: ",",
        limit: 2
      },
      {
        contents: "hello",
        sep: "",
        limit: 2
      },
      {
        contents: "aa",
        sep: "",
        limit: 2
      },
      {
        contents: ",",
        sep: ",",
        limit: 0
      },
      {
        contents: ",",
        sep: ",",
        limit: 1
      },
      {
        contents: ",",
        sep: ",",
        limit: 2
      },
      {
        contents: ",",
        sep: ",",
        limit: 3
      },
    ].each do |h|
      assert_string_split args, assert, h
    end
  end

  # def test_string_split_benchmark args, assert
  #   contents = "846,360,25,50,orange,1,sprites/bricks/orange_brick.png,v"

  #   GTK.benchmark seconds: 1, # number of seconds to run each experiment
  #                             # label for experiment
  #                 split: -> () {
  #                   # experiment body
  #                   contents.split ","
  #                 },
  #                 # label for experiment
  #                 split_new: -> () {
  #                   # experiment body
  #                   String.split(contents, ",")
  #                 }

  #   assert.ok!
  # end

```

### Unit Tests - suggest_autocompletion_tests.rb
```ruby
  # ./samples/10_advanced_debugging/03_unit_tests/suggest_autocompletion_tests.rb
  def default_suggest_autocompletion args
    {
      index: 4,
      text: "args.",
      __meta__: {
        other_options: [
          {
            index: Fixnum,
            file: "app/main.rb"
          }
        ]
      }
    }
  end

  def assert_completion source, *expected
    results = suggest_autocompletion text:  (source.strip.gsub  ":cursor", ""),
                                     index: (source.strip.index ":cursor")

    puts results
  end

  def test_args_completion args, assert
    GTK.write_file_root "autocomplete.txt", (GTK.suggest_autocompletion text: <<-S, index: 128).join("\n")
  require 'app/game.rb'

  def tick args
    GTK.suppress_mailbox = false
    $game ||= Game.new
    $game.args = args
    $game.args.
    $game.tick
  end
  S

    puts "contents:"
    puts (GTK.read_file "autocomplete.txt")
  end

```
