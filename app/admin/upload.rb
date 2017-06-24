ActiveAdmin.register Upload do
  menu priority: 999
  actions :index, :new, :create
  before_action :set_user, only: [:create]

  permit_params :model, :file

  form title: 'Upload Tabela' do |f|
    f.inputs "" do
      f.input :model
      f.input :file, as: :file
    end
    f.actions
  end

  controller do

    def create
      super
    end

    def build_new_resource
      upload = super
      if action_name == 'new' && params[:model]
        upload.model = params[:model]
      end
      upload
    end

    def set_user
      params[:upload][:user_id] = current_user.id
    end
  end
end
