class CollectionsController < ApplicationController
  after_filter :set_current_collection 

  def set_current_collection
    # if not @current_user.current_collection
    #   flash[:notice] = 'NO CURRENT COLLECTION'
    #   puts 'NO CURRENT COLLECTION ------------------------------------'
    # end
  end

  def new
    @collection = Collection.new
  end

  def edit
    if can? :manage, Collection
      @collection = Collection.find(params[:id])
      @problems = @collection.problems
    else
      flash[:notice] = "you do not have permission to access this page"
      redirect_to profile_path
    end
  end

  # creates a new collection with user specified values and sets as current collection
  def create
    collection_hash = params[:collection]
    if not (collection = @current_user.collections.create(collection_hash)).valid?
      flash[:notice] =  collection.errors.messages.map {|key, value| key.to_s + ' ' + value.to_s}.join ' ,'
      flash.keep
    end
    redirect_to profile_path
  end

  def show
    @collection = Collection.find(params[:id])
    @problems = @collection.problems
  end

  def update
    if not (collection = Collection.update(params[:id], params[:collection])).valid?
      flash[:notice] =  collection.errors.messages.map {|key, value| key.to_s + ' ' + value.to_s}.join ' ,'
      flash.keep
    end
    redirect_to profile_path
  end

  def destroy
    Collection.find(params[:id]).destroy
    flash[:notice] = 'Collection deleted'
    flash.keep
    redirect_to profile_path
  end

  def export
    
    @html_code = Collection.find(params[:id]).export('Html5')
    @edx_code = Collection.find(params[:id]).export('EdXml')
    @autoqcm_code = Collection.find(params[:id]).export('AutoQCM')

    if not @html_code
      flash[:notice] = 'Cannot export an empty collection! Add some questions to your collection first!'
      flash.keep
      redirect_to edit_collection_path( id: params[:id])
    end
  end

  def finalize_upload
    @collections = params[:ids].map{|collection_id| Collection.find(collection_id)}
  end
end
