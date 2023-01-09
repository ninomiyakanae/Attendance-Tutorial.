# coding: utf-8

User.create!(name: "Sample User",
             email: "sample@email.com",
             password: "password",
             password_confirmation: "password",
             admin: true)

9.times do |n|
  name = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
              email: email,
              password: password,
              password_confirmation: password)
              
  name = Faker::Name.上長A
  email = "sample--1@email.com"
  password = "password"
  User.create!(name: name,
              email: email,
              password: password,
              password_confirmation: password)              
end