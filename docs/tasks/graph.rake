require 'graphviz'

namespace :graph do
  task machines: :environment do
    [ImportMicroMachine, SyncMicroMachine].each do |klass|
      machine = klass.start(nil, nil)

      graph = GraphViz.new(:G, type: :digraph)
      graph[:rankdir] = 'LR'
      nodes = machine.states.map { |state| graph.add_nodes(state) }

      transitions = machine.transitions_for.values.flat_map(&:to_a)

      transitions.each do |transition|
        from, to = transition.map { |id| nodes.find { |node| node.id == id } }
        graph.add_edges(from, to)
      end

      graph.output png: "docs/#{klass}_graph.png"
    end
  end

  task :organization, [:id] => :environment do |_, args|
    id = args[:id]
    organization = Organization.find id

    graph = GraphViz.new(:G, use: :fdp)

    org_node = graph.add_nodes('organization')

    relations = organization.send(:auditable_relations)

    relations.each do |relation|
      records = organization.send(relation)
      relation_node = graph.add_nodes(relation)
      graph.add_edges(org_node, relation_node)
      records.each do |record|
        label = [relation, record.id].join("\n")
        auditable_node = graph.add_nodes(label)
        graph.add_edges(relation_node, auditable_node)
      end
    end

    organization.tags.each do |tag|
      label = ['tag', tag.name].join("\n")
      tag_node = graph.add_nodes(label)
      graph.add_edges(org_node, tag_node)
    end

    graph.output png: "#{id}_graph.png"
  end
end
