if defined?(JRUBY_VERSION)
  puts "JRuby Version: #{JRUBY_VERSION}"
else
  puts "MRI"
end
puts "Ruby Version: #{RUBY_VERSION}"

class T
  attr_reader :a, :b
  def initialize(a, b)
    @a = a
    @b = b
  end

  def to_s
    "a=#{a}, b=#{b}"
  end

  def inspect
    "A=#{a}, B=#{b}"
  end

  def <=>(other)
    # puts "comparing self=#{__id__}, with other=#{other.__id__}"
    # puts "comparing b=#{b} to other.a=#{other.a}"
    b <=> other.a ## BUG: typo!
  end
end

def rand
  1000.0 + Random.rand(1500)
end

$as = []
$bs = []

# JRuby:
# < 90 is fine
# 90 - 100 intermittent
# > 150 always
#
# MRI:
# even 15,000 is fine!
300.times do
  $as << rand
  $bs << rand
end

$all = $as.zip($bs)
$ns = $all.map { |a, b| T.new(a, b) }
$ns.sort
