# encoding: UTF-8

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

str = IO.readlines('example.txt', 'r:iso-8859-1')
#str.each { |s| puts s.encoding }
puts str


tree = AVLTree.new

tree[78] = 12
tree[3] = 2
tree[5] = 10
tree[2] = 223

tree.each { |key, value| puts "#{key} => #{value}\n" }
puts tree.include? 78

s = "здрасти"
puts "здрасти"

dict = German::Dictionary.new('example.txt')
#puts dict.view_word('Hund')
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
# chcp 65001

