
//本地电影图片
export function getPicByMovieId(movieId) {
  //const baseUrl = 'http://192.168.151.49:8080/pic/'
  const baseUrl = 'http://localhost:8080/pic/'
  //数据库中有数据
  return baseUrl + movieId + '.jpg'

}

export function getOnePic(movieId) {
  //const baseUrl = 'http://192.168.151.49:8080/pic/'
  const baseUrl = 'http://localhost:8080/pic/'
  //数据库中有数据
  return baseUrl + "copy" + movieId + '.jpg'

}
export function getUsername(user) {
  if (user.hasOwnProperty('userNickname') && user.userNickname) {
    return user.userNickname;
  } else {
    let name = "用户"
    if (user.userPhone) {
      name += user.userPhone.slice(0, 8)
    }
    else if (user.userEmail) {
      name += user.userEmail.slice(0, 8)
    }
    else {
      name = ''
    }
    return name

  }
}

//用户头像处理
export function getAvartar(url) {
  //const baseUrl = 'http://192.168.151.49:8080/pic/'
  const baseUrl = 'http://localhost:8080/pic/'
  //数据库中有数据
  if (url) {
    return baseUrl + url
  }
  else {
    return "../../static/imgs/avartar.jpg"
  }
}




