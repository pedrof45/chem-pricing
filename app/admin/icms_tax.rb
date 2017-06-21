ActiveAdmin.register IcmsTax do
  permit_params :origin, :destination, :value
  actions :all, except: :show


  controller do
    before_action :skip_sidebar!
    def index
      @origins = IcmsTax.origins
      @destinations = IcmsTax.destinations
      @icms = @origins.map { |orig| [orig, {} ] }.to_h
      IcmsTax.all.each do |i_tax|
        @icms[i_tax.origin][i_tax.destination] = i_tax
      end
      super
    end
  end

  index do
    render '/icms_matrix'
    actions
  end

end
