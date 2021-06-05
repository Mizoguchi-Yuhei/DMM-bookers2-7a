class BooksController < ApplicationController
  def show
    @new_book = Book.new
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
  end

  def index
    @user = current_user
    # @books = Book.joins(:favorites).where(favorites: {created_at: 0.days.ago.prev_week..0.days.ago.prev_week})
    # @books = Book.find(Favorite.group(:book_id).order('count(book_id) desc').pluck(:book_id))

    # to = Time.current.at_end_of_day
    # from = (to- 6.day).at_beginning_of_day
    # @books = Book.includes(:favorited_users).where(favorites: {created_at: from...to}).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}
    @books = Book.includes(:favorites).sort {|a,b| b.favorites.size <=> a.favorites.size}
    # 全期間でのいいね数順(いいね0を含む)
    @new_book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      redirect_to books_path
      flash[:alert] = "can't be blank"
    end
  end

  def edit
    @book = Book.find(params[:id])
    redirect_to books_path if @book.user_id != current_user.id
  end


  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
