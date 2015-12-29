require 'io/console'
require 'avl_tree'

require_relative 'dictionary'


=begin
file = File.new("example.txt", "w")
if file
  file.write("Hello")
  file.write("Hi")

  lines = file.readlines()
end
=end


tree = AVLTree.new

tree[78] = 12
tree[3] = 2
tree[5] = 10
tree[2] = 223

tree.each { |key, value| puts "#{key} => #{value}\n" }
puts tree.has_key? 78

=begin
h = { 3 => 2, 5 => 10, 78 => 12 }
puts h

arr = Array.new
arr << "Howdy\n"
arr << "Kak e\n"
arr << "Ko staa\n"
p arr[0..1].join
=end

# rspec spec.rb --require ./main.rb --colour --format documentation

