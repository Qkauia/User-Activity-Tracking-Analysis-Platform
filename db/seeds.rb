puts "建立資料中..."

User.create!(email: 'admin@test.com', password: '111111', password_confirmation: '111111', admin: true)

puts "系統管理員<<#{Admin.email}>>建立完成！"