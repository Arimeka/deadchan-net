class Lodge::UsersController < Lodge::LodgeController
  expose(:users)  { User.paginate(page: params[:page], per_page: 30) }

end