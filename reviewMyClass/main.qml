import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import File 1.0

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    property var dataJson
    property var keyWord
    FontLoader{id: textFont; source: "font/PingFangM.ttf"}
    Component.onCompleted: {
        var json = File.read(File.dataPath('data.json'))
        console.log(File.exist(File.dataPath('data.json')))
        dataJson = JSON.parse(json)
        var json2 = File.read(File.dataPath('keyWords.json'))
        keyWord = JSON.parse(json2)
    }

    ComboBox{
        id: subject
        width: 100
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        property var myModel: []
        Component.onCompleted: {
            var i
            for( i in dataJson){
                myModel.push(i)
            }
            model = myModel
        }
        onCurrentTextChanged: {
            var key = currentText
            charpterUpdate(key)
        }
    }
    ComboBox{
        id: charpter
        width: 200
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 50
        property var myModel: []
        Component.onCompleted: {
            var i
            var key = subject.currentText ? subject.currentText : "离散数学"
            for(i in dataJson[key]){
                myModel.push(i)
            }
            model = myModel
        }
        onCurrentTextChanged: {
            var key1 = subject.currentText ? subject.currentText : "离散数学"
            var key2 = currentText ? currentText : "第一章 命题逻辑"
            paraUpdate(key1, key2)
        }
    }
    function charpterUpdate(key){
        var newModel = []
        var i
        if(dataJson[key])
            for(i in dataJson[key]){
                newModel.push(i)
            }
        charpter.model = newModel
    }

    ComboBox{
        id: para
        width: 200
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 80
        property var myModel: []
        Component.onCompleted: {
            var i
            var key1 = subject.currentText ? subject.currentText : "离散数学"
            var key2 = charpter.currentText ? charpter.currentText : "第一章 命题逻辑"
            for(i in dataJson[key1][key2]){
                myModel.push(i)
            }
            model = myModel
        }
        onCurrentTextChanged: {
            var key1 = subject.currentText ? subject.currentText : "离散数学"
            var key2 = charpter.currentText ? charpter.currentText : "第一章 命题逻辑"
            var key3 = para.currentText ? para.currentText : "1.1 命题和连结词"
            whatIsItUpdate(key1, key2, key3)
        }
    }
    function paraUpdate(key1, key2){
        var newModel = []
        var j
        if(dataJson[key1][key2])
            for(j in dataJson[key1][key2]){
                newModel.push(j)
            }
        console.log(newModel)
        para.model = newModel

    }
    ComboBox{
        id: whatIsIt
        width: 200
        anchors.top: parent.top
        anchors.topMargin: 120
        anchors.left: parent.left
        anchors.leftMargin: 50
        property var myModel: []
        Component.onCompleted: {
            var i
            var key1 = subject.currentText ? subject.currentText : "离散数学"
            var key2 = charpter.currentText ? charpter.currentText : "第一章 命题逻辑"
            var key3 = para.currentText ? para.currentText : "1.1 命题和连结词"
            for(i in dataJson[key1][key2][key3]){
                myModel.push(i)
            }
            model = myModel
        }
        onCurrentTextChanged: {
            var key1 = subject.currentText ? subject.currentText : "离散数学"
            var key2 = charpter.currentText ? charpter.currentText : "第一章 命题逻辑"
            var key3 = para.currentText ? para.currentText : "1.1 命题和连结词"
            var key4 = whatIsIt.currentText ? whatIsIt.currentText : "命题"
            isWhatUpdate(key1, key2, key3, key4)
        }
    }
    function whatIsItUpdate(key1, key2, key3){
        var i
        var newModel = []
        if(dataJson[key1][key2][key3])
            for(i in dataJson[key1][key2][key3]){
                newModel.push(i)
            }
        whatIsIt.model = newModel
    }
    TextField{
        id: input
        anchors.top: whatIsIt.bottom
        anchors.topMargin: 10
        anchors.left: whatIsIt.left
        width: 200
        text: "在这里可以进行搜索"
        onTextChanged: search(text)
    }
    TextArea{
        id: output
        anchors.top: input.bottom
        anchors.topMargin: 10
        anchors.left: input.left
        width: 200
        height: 200
        property string subject: ""
        property string charpter: ""
        property string para: ""
        textFormat: Text.RichText
        font.family: textFont.name
        font.pixelSize: 15
        text: "可能在:<br>    科目: <br>    章: <br>    节: "
        function textChange(){
            output.text = "可能在:<br>    科目: " + output.subject + "<br>    章: " + output.charpter + "<br>    节: " + output.para
        }
    }

    function search(text){
        var words = []
        words = getKeyWords(text)
        if(words.length === 0){
//            output.subject = "抱歉,没有找到"
//            output.charpter = "抱歉, 没有找到"
//            output.para = "抱歉, 没有找到"
            return
        }

        var i, j = ""
        var len = words.length
        var ran = Math.floor(Math.random()*len)
        j = words[ran]
        console.log("Debug2 ", words, j)
        var ans = keyWord[j]
        if(ans[0] === 1){
            output.subject = "离散数学"
        }else if(ans[0] === 2){
            output.subject = "计算机组成原理"
        }
        if(ans[1] === 0){
            output.charpter = "各种章"
        }else
            output.charpter = "第" + ans[1] + "章"
        if(ans[2] === 0){
            output.para = "各种节"
        }else
            output.para = "第" + ans[2] + "章"

        output.textChange()
    }
    function getKeyWords(text){
        var keyWords = []
        var i
        for(i in keyWord){
            if(text.indexOf(i) !== -1){
                keyWords.push(i)
            }
        }
        return keyWords
    }


    TextArea{
        id: isWhat
        width: 300; height: 300
        anchors.top: whatIsIt.top
        anchors.left: whatIsIt.right
        anchors.leftMargin: 30
        property string myText: ""
        font.family: textFont.name
        font.pixelSize: 15
        textFormat: Text.RichText
        Component.onCompleted: {
            var key1 = subject.currentText ? subject.currentText : "离散数学"
            var key2 = charpter.currentText ? charpter.currentText : "第一章 命题逻辑"
            var key3 = para.currentText ? para.currentText : "1.1 命题和连结词"
            var key4 = whatIsIt.currentText ? whatIsIt.currentText : "命题"
            myText = dataJson[key1][key2][key3][key4]
            text = myText
        }
    }
    function isWhatUpdate(key1, key2, key3, key4){
        if(dataJson[key1][key2][key3][key4])
            isWhat.text = dataJson[key1][key2][key3][key4]
    }
}
