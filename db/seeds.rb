# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

Category.create([
                  { name: "Salary", financial_type: 'income' },
                  { name: "Food", financial_type: "expense" },
                  { name: "Clothing", financial_type: "expense" },
                  { name: "Household", financial_type: "expense" },
                  { name: "Transportation", financial_type: "expense" },
                  { name: "Health", financial_type: "expense" },
                  { name: "Personal", financial_type: "expense" },
                ])
