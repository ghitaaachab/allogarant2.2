class ContactsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def index
    @contacts = Contact.all
    @contacts = Contact.order(created_at: :desc).page(params[:page]).per(10)
    render :index
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.allowed_msg
      if @contact.save
        redirect_to root_path, notice: "Votre message a été envoyé avec succès !"
      else
        flash.now[:alert] = "Erreur lors de l'enregistrement du message."
        render :new
      end
    else
      flash.now[:alert] = "Message indésirable."
      render :new
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    redirect_to contacts_path, notice: "Contact message deleted!"
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :message, :full_name, :phone, :subject)
  end
end
