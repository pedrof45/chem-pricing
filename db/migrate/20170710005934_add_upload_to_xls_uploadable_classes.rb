class AddUploadToXlsUploadableClasses < ActiveRecord::Migration[5.1]
  def change
    add_reference :chopped_bulk_freights, :upload, index: true
    add_reference :cities, :upload, index: true
    add_reference :costs, :upload, index: true
    add_reference :customers, :upload, index: true
    add_reference :especial_packed_freights, :upload, index: true
    add_reference :icms_taxes, :upload, index: true
    add_reference :normal_bulk_freights, :upload, index: true
    add_reference :normal_packed_freights, :upload, index: true
    add_reference :optimal_markups, :upload, index: true
    add_reference :packagings, :upload, index: true
    add_reference :products, :upload, index: true
    add_reference :product_bulk_freights, :upload, index: true
    add_reference :quotes, :upload, index: true
    add_reference :sales, :upload, index: true
    add_reference :vehicles, :upload, index: true
  end
end
