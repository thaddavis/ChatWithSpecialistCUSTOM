class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.references :user, foreign_key: true
      t.string :invoice_stripe_id
      t.string :subscription_stripe_id
      t.string :type_of_invoice
      t.integer :amount
      t.string :description
      t.string :date_of_invoice
      t.string :card_charged

      t.timestamps
    end
  end
end
