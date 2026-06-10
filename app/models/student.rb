class Student < ApplicationRecord
    validates :name,presence: true
    validates :email,presence: true,uniqueness: true
    validates :age,presence: true,numericality: {greater_than: 0}
    validates :course,presence: true
    validates :city,presence: true
    validates :marks,presence: true,numericality:{greater_than_or_equal_to: 0,less_than_or_equal_to: 100}
    def result
        if marks>=35
            "pass"
        else
            "fail"
        end
    end
end
