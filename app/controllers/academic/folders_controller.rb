# frozen_string_literal: true

class Academic::FoldersController < AcademicController
  before_action :set_folder, only: %i[show edit update destroy]
  before_action :set_current_path

  def show
    @quizzes = if params[:query].present?
                 current_academic.quizzes.where(folder_id: params[:id]).where(
                   'LOWER(name) LIKE ?', "%#{params[:query].downcase}%"
                 )
               else
                 current_academic.quizzes.where(folder_id: params[:id])
               end
  end

  def edit; end

  def new
    @folder = Folder.new
  end

  def create
    @folder = Folder.new(folder_params)
    @folder.academic = current_academic

    if @folder.valid? && @folder.save
      flash[:notice] = 'Successfully created new Folder!'
      redirect_to academic_folder_path(@folder)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @folder.update(folder_params)
      redirect_to academic_folder_path(@folder)
      flash[:notice] = 'Successfully updated the Folder!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @folder = current_academic.folders.find(params[:id])
    if @folder.destroy
      redirect_to academic_resources_path
      flash[:notice] = 'Successfully deleted the Folder!'
    else
      flash[:alert] = 'Could not delete the Folder!'
    end
  end

  private

  def set_folder
    @folder = current_academic.folders.find(params[:id])
  end

  def folder_params
    params.require(:folder).permit(:name)
  end

  def set_current_path
    @current_path = request.path
  end
end
