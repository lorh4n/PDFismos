import QtQml.Models

ListModel {
    id: tabs

    function indexOfUrl(url) {
        for (let i = 0; i < tabs.count; i++) {
            if (tabs.get(i).tabUrl === url)
                return i;
        }

        return -1;
    }
}