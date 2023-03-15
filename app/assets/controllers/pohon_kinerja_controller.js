// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"

import 'd3-mitch-tree/dist/css/d3-mitch-tree-theme-default.min.css'
export default class extends Controller {
        static targets = ["pokin", "buttonToggle"]

        static values = {
                opd: Number,
                tahun: Number,
                render: Boolean
        }

        togglePokin() {
                const isShow = !this.renderValue
                this.showPokin(isShow)
                this.renderValue = isShow
        }

        showPokin(isShow) {
                if (isShow) {
                        this.pokinTarget.style.display = 'block'
                        this.pokinRender()
                        this.buttonToggleTarget.classList.remove('btn-outline-success')
                        this.buttonToggleTarget.classList.add('btn-outline-danger')
                        this.buttonToggleTarget.innerText = 'Sembunyikan Pohon'
                }
                else {
                        this.pokinTarget.style.display = 'none'
                        this.buttonToggleTarget.classList.remove('btn-outline-danger')
                        this.buttonToggleTarget.classList.add('btn-outline-success')
                        this.buttonToggleTarget.innerText = 'Tampilkan Pohon'
                }
        }

        pokinTargetConnected() {
                this.pokinTarget.style.display = 'none'
        }

        mithTreeRender(data, targetEl) {
                const mitchTree = require('d3-mitch-tree')
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
                        .setOrientation('topToBottom')
                        .setAllowNodeCentering(true)
                        .setNodeDepthMultiplier(250)
                        .setWidthWithoutMargins(550)
                        .setHeightWithoutMargins(550)
                        .getNodeSettings()
                        .setSizingMode('nodeSize')
                        .setHorizontalSpacing(40)
                        .setVerticalSpacing(40)
                        .setBodyBoxWidth(350)
                        .setBodyBoxHeight(120)
                        .setBodyBoxPadding({
                                top: 5,
                                bottom: 5,
                                right: 7,
                                left: 7
                        })
                        .back()
                        .initialize();
                return treePlugin;
        }

        pokinRender() {

                const targetEl = this.pokinTarget
                const url = `/opds/kotak_usulan.json?kode_opd=${this.opdValue}&tahun=${this.tahunValue}`
                fetch(url)
                        .then(response => response.json())
                        .then((data) => {
                                const treePlugin = this.mithTreeRender(data, targetEl)
                        })
        }

        expandAllTree(treePlugin) {
                var nodes = treePlugin.getNodes();
                nodes.forEach(function(node, index, arr) {
                        treePlugin.expand(node);
                });
                treePlugin.update(treePlugin.getRoot());
        }
}
