# rubocop:disable Rails/Output

puts "\nCriando roles padrão..."
Role.create_default_roles
puts "Roles criadas com sucesso. ✅\n\n"

puts "Limpando usuários existentes...\n\n"
User.destroy_all

puts "Criando usuários..."

users_data = [
  { email: 'admin@email.com', password: 'adminpassword', role: :admin },
  { email: 'operator@email.com', password: 'operatorpassword', role: :operator },
  { email: 'client@email.com', password: 'clientpassword', role: :client }
]

users_data.each do |data|
  user = User.create!(
    email: data[:email],
    password: data[:password],
    password_confirmation: data[:password]
  )
  user.add_role data[:role]
  puts "#{data[:role].capitalize}: #{user.email}"
end

puts "Usuários criados com sucesso. ✅\n\n"

# rubocop:enable Rails/Output
