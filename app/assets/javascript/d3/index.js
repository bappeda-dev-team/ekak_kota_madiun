import 'd3-mitch-tree/dist/css/d3-mitch-tree-theme-default.min.css'
const mitchTree = require('d3-mitch-tree')

// dummy data
var data = {
        "id": 1,
        "name": "Pohon Kinerja",
        "type": "Root",
        "description": "Kota Madiun",
        "children": [{
                "id": 2,
                "name": "Isu Strategis",
                "type": "isu_strategis_kota",
                "description": "Masih Terbatasnya Kualitas Sumber Daya Manusia",
                "children": [
                        {
                                "id": 3,
                                "name": "Strategi Kota",
                                "type": "strategi_kota",
                                "description": "Pemerataan Kualitas Sekolah",
                                "children": [
                                        {
                                                "id": 4,
                                                "name": "Perangkat Daerah",
                                                "type": "opd",
                                                "description": "Dinas Pendidikan",
                                        },

                                        {
                                                "id": 5,
                                                "name": "Perangkat Daerah",
                                                "type": "opd",
                                                "description": "Badan Perencanaan",
                                        },
                                        {
                                                "id": 6,
                                                "name": "Perangkat Daerah",
                                                "type": "opd",
                                                "description": "Dinas Pekerjaan Umum",
                                        },
                                ]
                        }
                ]
        }
        ]
};

function init() {
        const treePlugin = new mitchTree.boxedTree()
                .setData(data)
                .setElement(document.getElementById('pokin'))
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
}
window.addEventListener('DOMContentLoaded', init);
