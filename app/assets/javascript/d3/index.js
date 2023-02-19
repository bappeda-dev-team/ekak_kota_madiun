import 'd3-mitch-tree/dist/css/d3-mitch-tree-theme-default.min.css'
const mitchTree = require('d3-mitch-tree')

function init() {
        const tahun = 2023
        const targetEl = document.getElementById('pokin')
        if (targetEl) {
                fetch(`/isu_strategis_kota.json?tahun=${tahun}`)
                        .then(response => response.json())
                        .then((data) => {
                                const isu_kota = data['results']
                                new mitchTree.boxedTree()
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
                        })
        }
}
window.addEventListener('DOMContentLoaded', init);
