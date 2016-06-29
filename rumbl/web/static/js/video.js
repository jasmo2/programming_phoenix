import Player from "./player"

let Video = {

  init(socket, element){ if(!element){ return }
    let playerId = element.getAttribute("data-player-id")
    let videoId  = element.getAttribute("data-id")
    socket.connect()
    Player.init(element.id, playerId, () => {
      this.onReady(videoId, socket)
    })
  },

  onReady(videoId, socket){
    let msgContainer = document.getElementById("msg-container")
    let msgInput     = document.getElementById("msg-input")
    let postButton   = document.getElementById("msg-submit")
    let vidChannel   = socket.channel("videos_c:" + videoId)
    
    postButton.addEventListener('click', e => {
      let payload = {}
      vidChannel.push("new_annotation", payload)
      .receive("error", e => console.log(e))
      msgInput.value = ""
    })
    // join to VideoChannel
    vidChannel.join()
    .receive("ok", resp => console.log("joined video channel", resp ))
    .receive("error", resp => console.log("error: ", resp))

    vidChannel.on("new_annotation", (response) =>  {
      this.renderAnnotation(msgContainer, response)
    })
  },
  esc(str){
    let div = document.createElement("div")
    div.appendChild(document.createTextNode(str))
    return div.innerHTML
  },

  renderAnnotation(msgContainer, {user, body, at}){
    let template = document.createElement("div")

    template.innerHTML = `
    <a href="#" data-seek="${this.esc(at)}">
    <b>${this.esc(user.username)}</b>: ${this.esc(body)}
    </a>
    `
    msgContainer.appendChild(template)
    msgContainer.scrollTop = msgContainer.scrollHeight
  }
}
export default Video
