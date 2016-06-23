class AddCancelBeforeToNooks < ActiveRecord::Migration
	def up
		add_column :nooks, :cancel_before, :Integer
	end

	def down
		remove_column :nooks, :cancel_before, :Integer
	end
end