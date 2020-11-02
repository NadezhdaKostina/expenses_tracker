require 'rexml/document'
require 'date'

# Спросим у пользователя, на что он потратил деньги и сколько
puts "На что потратили деньги?"
expense_text = STDIN.gets.chomp

puts "Сколько потратили?"
expense_amount = STDIN.gets.chomp.to_i

# Спросим у пользователя, когда он потратил деньги
puts "Укажите дату траты в формате ДД.ММ.ГГГГ, например 12.05.2003 (пустое поле - сегодня)"
date_input = STDIN.gets.chomp

expense_date = nil

if date_input == ''
  expense_date = Date.today
else
  begin
    expense_date = Date.parse(date_input)
  rescue ArgumentError
    expense_date = Date.today
  end
end

# Наконец, спросим категорию траты
puts "В какую категорию занести трату"
expense_category = STDIN.gets.chomp

current_path = File.dirname(__FILE__)
file_name = current_path + "/expenses.xml"

file = File.new(file_name, 'r:utf-8')

begin
  doc = REXML::Document.new(file)
rescue REXML::ParseException => error
  puts "Похоже, файл #{file_name} испорчен:"
  abort error.message
end

file.close

expenses = doc.elements.find('expenses').first

expense = expenses.add_element 'expense', {
  'date' => expense_date.strftime('%Y.%m.%d'),
  'amount' => expense_amount,
  'category' => expense_category
}

expense.text = expense_text

file = File.new(file_name, 'w:utf-8')
doc.write(file, 2)
file.close

puts 'Запись успешно сохранена'