import 'd3-mitch-tree/dist/css/d3-mitch-tree-theme-default.min.css'
const mitchTree = require('d3-mitch-tree')

function init() {
        const tahun = 2023
        const targetEl = document.getElementById('pokin')
        const url = `/isu_strategis_kota.json?tahun=${tahun}`
        if (targetEl) {
                fetch(url)
                        .then(response => response.json())
                        .then((data) => {
                                const isu_kota = data['results']
                                const treePlugin = new mitchTree.boxedTree()
                                        .setData(isu_kota)
                                        .setElement(targetEl)
                                        .setIdAccessor(function(data) {
                                                return data.id;
                                        })
                                        .setChildrenAccessor(function(data) {
                                                return data.children;
                                        })
                                        .setBodyDisplayTextAccessor(function(data) {
                                                return data.description;
                                        })
                                        .setTitleDisplayTextAccessor(function(data) {
                                                return data.name;
                                        })
                                        .initialize();
                                var nodes = treePlugin.getNodes();
                                nodes.forEach(function (node, index, arr) {
                                        treePlugin.expand(node);
                                });
                                treePlugin.update(treePlugin.getRoot());
                        })
        }
}
window.addEventListener('DOMContentLoaded', init);
